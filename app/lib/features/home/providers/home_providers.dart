import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/class_record_dao.dart';
import 'package:class2data/data/database/daos/credit_transaction_dao.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/domain/services/schedule_occurrence_service.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 首页数据版本号，修改计划/课包后递增以触发刷新
final homeDataVersionProvider = StateProvider<int>((ref) => 0);

/// 首页日列表项：合并计划课和已记录信息
class HomeDayItem {
  final int scheduleId;
  final int kidCourseId;
  final String date;
  final String startTime;
  final String endTime;
  final String occurrenceKey;
  final String? classType;
  final String? classNameSnapshot;
  final int? recordId;
  final String? recordStatus; // attended|leave|cancelled|absent|makeup
  final bool hasAvailablePackage;
  final String? packageTypeLabel;
  final String? remainingCreditsLabel;

  const HomeDayItem({
    required this.scheduleId,
    required this.kidCourseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.occurrenceKey,
    this.classType,
    this.classNameSnapshot,
    this.recordId,
    this.recordStatus,
    this.hasAvailablePackage = true,
    this.packageTypeLabel,
    this.remainingCreditsLabel,
  });

  bool get isRecorded => recordId != null;
  bool get isPending => recordId == null;
}

/// 首页：生成一周内所有课程项（含已记录）
final weekHomeItemsProvider =
    FutureProvider.family<List<HomeDayItem>, WeekRange>((ref, week) async {
      ref.watch(homeDataVersionProvider);
      final db = ref.watch(databaseProvider);

      // 获取所有活跃课程 ID
      final coursesAsync = ref.watch(allActiveCoursesProvider);
      final allCourses = switch (coursesAsync) {
        AsyncData(:final value) => switch (value) {
          Ok(:final value) => value,
          Err() => <KidCourse>[],
        },
        _ => <KidCourse>[],
      };
      if (allCourses.isEmpty) return [];

      final courseIds = allCourses.map((c) => c.id).toSet();

      // 获取所有活跃计划
      final allSchedules = await (db.select(
        db.courseSchedules,
      )..where((t) => t.isPaused.equals(false))).get();
      final activeSchedules = allSchedules
          .where((s) => courseIds.contains(s.kidCourseId))
          .toList();

      // 生成所有课次（不过滤已记录）
      final service = ScheduleOccurrenceService();
      final allOccurrences = service.generateOccurrences(
        schedules: activeSchedules,
        existingRecords: [], // 不过滤已记录
        startDate: week.startDate,
        endDate: week.endDate,
      );

      // 获取已记录数据
      final classRecordDao = ClassRecordDao(db);
      final existingRecords = await classRecordDao.getByDateRange(
        week.startDate,
        week.endDate,
      );

      // 构建 scheduleId:occurrenceKey → ClassRecord 映射
      final recordByKey = <String, ClassRecord>{};
      for (final r in existingRecords) {
        if (r.scheduleId != null && r.scheduleOccurrenceKey != null) {
          recordByKey['${r.scheduleId}:${r.scheduleOccurrenceKey}'] = r;
        }
      }

      // 合并：课次 + 记录状态
      final items = <HomeDayItem>[];
      final matchedRecordIds = <int>{};

      for (final occ in allOccurrences) {
        final key = '${occ.scheduleId}:${occ.occurrenceKey}';
        final record = recordByKey[key];
        if (record != null) {
          matchedRecordIds.add(record.id);
        }
        items.add(
          HomeDayItem(
            scheduleId: occ.scheduleId,
            kidCourseId: occ.kidCourseId,
            date: occ.date,
            startTime: occ.startTime,
            endTime: occ.endTime,
            occurrenceKey: occ.occurrenceKey,
            classType: occ.classType,
            classNameSnapshot: occ.classNameSnapshot,
            recordId: record?.id,
            recordStatus: record?.status,
          ),
        );
      }

      // 添加不在计划中的独立记录（手动录入，仅关联活跃课程）
      for (final r in existingRecords) {
        if (!courseIds.contains(r.kidCourseId)) continue;
        if (r.scheduleId == null || !matchedRecordIds.contains(r.id)) {
          if (!matchedRecordIds.contains(r.id)) {
            items.add(
              HomeDayItem(
                scheduleId: r.scheduleId ?? -1,
                kidCourseId: r.kidCourseId,
                date: r.classDate,
                startTime: r.startTime,
                endTime: r.endTime ?? r.startTime,
                occurrenceKey: r.scheduleOccurrenceKey ?? 'record_${r.id}',
                classType: r.classType,
                classNameSnapshot: r.classNameSnapshot,
                recordId: r.id,
                recordStatus: r.status,
              ),
            );
          }
        }
      }

      // 按日期和时间排序
      items.sort((a, b) {
        final dateCmp = a.date.compareTo(b.date);
        if (dateCmp != 0) return dateCmp;
        return a.startTime.compareTo(b.startTime);
      });

      // 计算每门课的课包信息
      final packageInfo = await _computePackageInfo(db, courseIds);
      for (int i = 0; i < items.length; i++) {
        final info = packageInfo[items[i].kidCourseId];
        final itemDate = DateTime.parse(items[i].date);

        // 逐项检查周期卡在该日期是否有效
        final hasActivePeriodPack = (info?.periodPackages ?? []).any((p) {
          if (p.validFrom != null && itemDate.isBefore(p.validFrom!)) {
            return false;
          }
          if (p.validUntil != null && itemDate.isAfter(p.validUntil!)) {
            return false;
          }
          return true;
        });

        final hasAvailable =
            hasActivePeriodPack || (info?.hasCreditBalance ?? false);

        String? remainingLabel;
        if (hasActivePeriodPack) {
          remainingLabel = '有效';
        } else if (info?.hasCreditBalance == true) {
          remainingLabel = info?.remainingCreditsLabel;
        } else if (info?.periodPackages.isNotEmpty == true) {
          remainingLabel = '已过期';
        } else {
          remainingLabel = info?.remainingCreditsLabel;
        }

        items[i] = HomeDayItem(
          scheduleId: items[i].scheduleId,
          kidCourseId: items[i].kidCourseId,
          date: items[i].date,
          startTime: items[i].startTime,
          endTime: items[i].endTime,
          occurrenceKey: items[i].occurrenceKey,
          classType: items[i].classType,
          classNameSnapshot: items[i].classNameSnapshot,
          recordId: items[i].recordId,
          recordStatus: items[i].recordStatus,
          hasAvailablePackage: hasAvailable,
          packageTypeLabel: info?.typeLabel,
          remainingCreditsLabel: remainingLabel,
        );
      }

      return items;
    });

class _CoursePackageSummary {
  final bool hasCreditBalance;
  final String? typeLabel;
  final String? remainingCreditsLabel;
  final List<Package> periodPackages;

  const _CoursePackageSummary({
    required this.hasCreditBalance,
    this.typeLabel,
    this.remainingCreditsLabel,
    this.periodPackages = const [],
  });
}

Future<Map<int, _CoursePackageSummary>> _computePackageInfo(
  AppDatabase db,
  Set<int> courseIds,
) async {
  final result = <int, _CoursePackageSummary>{};
  final balanceService = CreditBalanceService();
  final txDao = CreditTransactionDao(db);

  for (final courseId in courseIds) {
    final packages =
        await (db.select(db.packages)
              ..where((t) => t.kidCourseId.equals(courseId))
              ..where((t) => t.isVoided.equals(false)))
            .get();

    // 课包类型标签：去重拼接
    final typeLabels = packages
        .map((p) => balanceService.packageTypeLabel(p.type))
        .toSet()
        .toList();
    final typeLabel = typeLabels.isNotEmpty ? typeLabels.join('、') : null;

    // 分离周期卡，供逐项按日期判断
    final periodPacks = packages.where((p) => p.type == 'period_pack').toList();

    // 课时余额
    final transactions = await txDao.getByCourseId(courseId);
    final balance = balanceService.courseBalance(transactions);
    result[courseId] = _CoursePackageSummary(
      hasCreditBalance: balance > 0,
      typeLabel: typeLabel,
      remainingCreditsLabel: balance > 0
          ? '余${balanceService.formatCredits(balance)}节'
          : (typeLabel != null ? '已用完' : null),
      periodPackages: periodPacks,
    );
  }
  return result;
}

/// 某门课程下所有计划
final schedulesByCourseProvider =
    StreamNotifierProvider.family<
      SchedulesByCourseNotifier,
      Result<List<CourseSchedule>>,
      int
    >(SchedulesByCourseNotifier.new);

class SchedulesByCourseNotifier
    extends FamilyStreamNotifier<Result<List<CourseSchedule>>, int> {
  @override
  Stream<Result<List<CourseSchedule>>> build(int arg) {
    final repo = ref.watch(scheduleRepositoryProvider);
    return repo.watchAllByCourseId(arg);
  }
}

class WeekRange {
  final String startDate;
  final String endDate;

  const WeekRange({required this.startDate, required this.endDate});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekRange &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => Object.hash(startDate, endDate);
}
