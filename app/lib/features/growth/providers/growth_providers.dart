import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/repositories/attachment_repository.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/features/achievements/providers/achievement_providers.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/class_records/providers/class_record_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/growth/models/growth_feed_event.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// === Statistics Filter ===

class StatisticsFilter {
  final String? dateFrom; // YYYY-MM
  final String? dateTo; // YYYY-MM

  const StatisticsFilter({this.dateFrom, this.dateTo});

  bool get showAllDates => dateFrom == null && dateTo == null;

  bool matchesMonth(String monthKey) {
    if (dateFrom != null && monthKey.compareTo(dateFrom!) < 0) return false;
    if (dateTo != null && monthKey.compareTo(dateTo!) > 0) return false;
    return true;
  }
}

final statisticsFilterProvider = StateProvider<StatisticsFilter>(
  (_) => const StatisticsFilter(),
);

/// 某孩子的课程统计数据
final childCourseStatisticsProvider =
    FutureProvider.family<Map<int, CourseStatistics>, int>((
      ref,
      childId,
    ) async {
      final coursesResult = await ref.watch(
        coursesByChildProvider(childId).future,
      );

      final courses = switch (coursesResult) {
        Ok(:final value) => value,
        Err() => <KidCourse>[],
      };

      final filter = ref.watch(statisticsFilterProvider);
      final service = CourseStatisticsService();
      final stats = <int, CourseStatistics>{};

      for (final course in courses) {
        final recordsResult = await ref.watch(
          classRecordsByCourseProvider(course.id).future,
        );
        var records = switch (recordsResult) {
          Ok(:final value) => value,
          Err() => <ClassRecord>[],
        };

        final transactionsResult = await ref.watch(
          creditTransactionByCourseProvider(course.id).future,
        );
        var transactions = switch (transactionsResult) {
          Ok(:final value) => value,
          Err() => <CreditTransaction>[],
        };

        final paymentsResult = await ref.watch(
          paymentsByCourseProvider(course.id).future,
        );
        var payments = switch (paymentsResult) {
          Ok(:final value) => value,
          Err() => <Payment>[],
        };

        final packagesResult = await ref.watch(
          packagesByCourseProvider(course.id).future,
        );
        var pkgs = switch (packagesResult) {
          Ok(:final value) => value,
          Err() => <Package>[],
        };

        if (!filter.showAllDates) {
          records = records
              .where((r) => filter.matchesMonth(r.classDate.substring(0, 7)))
              .toList();
          transactions = transactions
              .where(
                (t) => filter.matchesMonth(_dateTimeToMonth(t.transactionDate)),
              )
              .toList();
          payments = payments
              .where(
                (p) => filter.matchesMonth(_dateTimeToMonth(p.paymentDate)),
              )
              .toList();
          pkgs = pkgs
              .where(
                (p) => filter.matchesMonth(_dateTimeToMonth(p.purchaseDate)),
              )
              .toList();
        }

        stats[course.id] = service.computeStatistics(
          records: records,
          transactions: transactions,
          payments: payments,
          packages: pkgs,
        );
      }

      return stats;
    });

String _dateTimeToMonth(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
}

/// 某孩子的汇总统计
final childTotalStatisticsProvider =
    FutureProvider.family<CourseStatistics, int>((ref, childId) async {
      final statsMap = await ref.watch(
        childCourseStatisticsProvider(childId).future,
      );

      int classCount = 0;
      int totalDuration = 0;
      int consumedCredits = 0;
      int totalSpent = 0;
      int purchasedCredits = 0;

      for (final s in statsMap.values) {
        classCount += s.classCount;
        totalDuration += s.totalDurationMinutes;
        consumedCredits += s.consumedCredits;
        totalSpent += s.totalSpentCents;
        purchasedCredits += s.purchasedCredits;
      }

      return CourseStatistics(
        classCount: classCount,
        totalDurationMinutes: totalDuration,
        consumedCredits: consumedCredits,
        totalSpentCents: totalSpent,
        remainingCredits: purchasedCredits - consumedCredits,
        purchasedCredits: purchasedCredits,
      );
    });

/// 某孩子的时间线事件
final childTimelineProvider = FutureProvider.family<List<TimelineEvent>, int>((
  ref,
  childId,
) async {
  final coursesResult = await ref.watch(coursesByChildProvider(childId).future);
  final courses = switch (coursesResult) {
    Ok(:final value) => value,
    Err() => <KidCourse>[],
  };

  final service = CourseStatisticsService();

  // 收集所有上课记录
  final allRecords = <ClassRecord>[];
  for (final course in courses) {
    final recordsResult = await ref.watch(
      classRecordsByCourseProvider(course.id).future,
    );
    final records = switch (recordsResult) {
      Ok(:final value) => value,
      Err() => <ClassRecord>[],
    };
    allRecords.addAll(records);
  }

  // 收集所有成就
  final achievementsResult = await ref.watch(
    achievementsByChildProvider(childId).future,
  );
  final achievements = switch (achievementsResult) {
    Ok(:final value) => value,
    Err() => <Achievement>[],
  };

  // 收集所有课包
  final allPackages = <Package>[];
  for (final course in courses) {
    final packagesResult = await ref.watch(
      packagesByCourseProvider(course.id).future,
    );
    final packages = switch (packagesResult) {
      Ok(:final value) => value,
      Err() => <Package>[],
    };
    allPackages.addAll(packages);
  }

  return service.buildTimeline(
    records: allRecords,
    achievements: achievements,
    packages: allPackages,
  );
});

// === 缺失的中间 provider ===

/// 某课程的课时流水
final creditTransactionByCourseProvider =
    StreamNotifierProvider.family<
      CreditTransactionByCourseNotifier,
      Result<List<CreditTransaction>>,
      int
    >(CreditTransactionByCourseNotifier.new);

class CreditTransactionByCourseNotifier
    extends FamilyStreamNotifier<Result<List<CreditTransaction>>, int> {
  @override
  Stream<Result<List<CreditTransaction>>> build(int arg) {
    final repo = ref.watch(creditTransactionRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 某课程的费用记录
final paymentsByCourseProvider =
    StreamNotifierProvider.family<
      PaymentsByCourseNotifier,
      Result<List<Payment>>,
      int
    >(PaymentsByCourseNotifier.new);

class PaymentsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Payment>>, int> {
  @override
  Stream<Result<List<Payment>>> build(int arg) {
    final repo = ref.watch(paymentRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

// === Growth Feed ===

final growthFilterProvider = StateProvider<GrowthFilter>(
  (_) => const GrowthFilter(),
);

final growthFeedProvider = FutureProvider<List<GrowthFeedEvent>>((ref) async {
  final filter = ref.watch(growthFilterProvider);
  final childrenResult = await ref.watch(activeChildrenProvider.future);
  final children = switch (childrenResult) {
    Ok(:final value) => value,
    Err() => <ChildrenData>[],
  };

  final targetChildren = filter.showAllChildren
      ? children
      : children.where((c) => c.id == filter.childId).toList();

  if (targetChildren.isEmpty) return [];

  final fileService = ref.watch(attachmentFileServiceProvider);
  final attachmentRepo = ref.watch(attachmentRepositoryProvider);
  final events = <GrowthFeedEvent>[];

  for (final child in targetChildren) {
    final coursesResult = await ref.watch(
      coursesByChildProvider(child.id).future,
    );
    final courses = switch (coursesResult) {
      Ok(:final value) => value,
      Err() => <KidCourse>[],
    };

    // ── Class Records ──
    if (filter.showsType('class_record')) {
      final allRecords = <ClassRecord>[];
      final courseMap = <int, KidCourse>{};
      for (final course in courses) {
        courseMap[course.id] = course;
        final recordsResult = await ref.watch(
          classRecordsByCourseProvider(course.id).future,
        );
        final records = switch (recordsResult) {
          Ok(:final value) => value,
          Err() => <ClassRecord>[],
        };
        allRecords.addAll(records);
      }

      final recordIds = allRecords.map((r) => r.id).toList();
      final attachmentMap = await _batchGetAttachmentPaths(
        attachmentRepo,
        fileService,
        'class_record',
        recordIds,
      );

      for (final r in allRecords) {
        final course = courseMap[r.kidCourseId];
        events.add(
          GrowthFeedEvent(
            sortDateTime: _parseClassDateTime(r.classDate, r.startTime),
            type: 'class_record',
            childId: child.id,
            childName: child.name,
            childAvatarPath: child.avatarPath,
            courseId: course?.id,
            courseName: course?.name,
            title: course?.name ?? r.classNameSnapshot ?? '上课记录',
            subtitle: _classRecordSubtitle(r),
            notes: r.notes,
            imagePaths: attachmentMap[r.id] ?? [],
            recordId: r.id,
            recordStatus: r.status,
            timeRange: r.endTime != null
                ? '${r.startTime} - ${r.endTime}'
                : r.startTime,
          ),
        );
      }
    }

    // ── Achievements ──
    if (filter.showsType('achievement')) {
      final achievementsResult = await ref.watch(
        achievementsByChildProvider(child.id).future,
      );
      final achievements = switch (achievementsResult) {
        Ok(:final value) => value,
        Err() => <Achievement>[],
      };

      final achievementIds = achievements.map((a) => a.id).toList();
      final attachmentMap = await _batchGetAttachmentPaths(
        attachmentRepo,
        fileService,
        'achievement',
        achievementIds,
      );

      final achievementRepo = ref.read(achievementRepositoryProvider);
      for (final a in achievements) {
        final course = a.kidCourseId != null
            ? courses.where((c) => c.id == a.kidCourseId).firstOrNull
            : null;
        final paymentResult = await achievementRepo.getPaymentByAchievementId(
          a.id,
        );
        final payment = switch (paymentResult) {
          Ok(:final value) => value,
          Err() => null,
        };
        events.add(
          GrowthFeedEvent(
            sortDateTime: _parseDate(a.achievementDate),
            type: 'achievement',
            childId: child.id,
            childName: child.name,
            childAvatarPath: child.avatarPath,
            courseId: course?.id,
            courseName: course?.name,
            title: _achievementTitle(a, course),
            subtitle: _achievementPaymentSubtitle(payment),
            notes: a.notes ?? a.description,
            imagePaths: attachmentMap[a.id] ?? [],
            achievementId: a.id,
          ),
        );
      }
    }

    // ── Packages ──
    if (filter.showsType('package')) {
      final allPackages = <Package>[];
      final pkgCourseMap = <int, KidCourse>{};
      for (final course in courses) {
        pkgCourseMap[course.id] = course;
        final packagesResult = await ref.watch(
          packagesByCourseProvider(course.id).future,
        );
        final packages = switch (packagesResult) {
          Ok(:final value) => value,
          Err() => <Package>[],
        };
        allPackages.addAll(packages);
      }

      final packageIds = allPackages.map((p) => p.id).toList();
      final attachmentMap = await _batchGetAttachmentPaths(
        attachmentRepo,
        fileService,
        'package',
        packageIds,
      );

      final formatter = CreditBalanceFormatter();
      for (final p in allPackages) {
        if (p.isVoided) continue;
        final course = pkgCourseMap[p.kidCourseId];
        events.add(
          GrowthFeedEvent(
            sortDateTime: p.purchaseDate,
            type: 'package',
            childId: child.id,
            childName: child.name,
            childAvatarPath: child.avatarPath,
            courseId: course?.id,
            courseName: course?.name,
            title:
                '购入${course?.name ?? ''}${formatter.packageTypeLabel(p.type)}',
            subtitle: _packageSubtitle(p, formatter),
            notes: p.notes,
            imagePaths: attachmentMap[p.id] ?? [],
            packageId: p.id,
          ),
        );
      }
    }
  }

  events.sort((a, b) => b.sortDateTime.compareTo(a.sortDateTime));

  if (!filter.showAllDates) {
    return events.where((e) => filter.matchesDate(e.dateKey)).toList();
  }
  return events;
});

Future<Map<int, List<String>>> _batchGetAttachmentPaths(
  AttachmentRepository repo,
  AttachmentFileService fileService,
  String ownerType,
  List<int> ownerIds,
) async {
  if (ownerIds.isEmpty) return {};

  final result = await repo.getByOwnerIds(ownerType, ownerIds);
  final attachments = switch (result) {
    Ok(:final value) => value,
    Err() => <Attachment>[],
  };

  final map = <int, List<String>>{};
  for (final a in attachments) {
    final path = await fileService.getAbsolutePath(a.relativePath);
    if (File(path).existsSync()) {
      map.putIfAbsent(a.ownerId, () => []).add(path);
    }
  }
  return map;
}

DateTime _parseClassDateTime(String classDate, String startTime) {
  final d = DateTime.tryParse(classDate);
  if (d == null) return DateTime.now();
  final parts = startTime.split(':');
  if (parts.length >= 2) {
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return DateTime(d.year, d.month, d.day, hour, minute);
  }
  return d;
}

DateTime _parseDate(String dateStr) {
  return DateTime.tryParse(dateStr) ?? DateTime.now();
}

String? _classRecordSubtitle(ClassRecord r) {
  final parts = <String>[];
  if (r.durationMinutes != null) parts.add('${r.durationMinutes}分钟');
  if (r.creditUnitsCost > 0) {
    parts.add(
      '消耗${CreditBalanceFormatter().formatCredits(r.creditUnitsCost)}课时',
    );
  }
  return parts.isEmpty ? null : parts.join(' · ');
}

String _achievementTitle(Achievement a, KidCourse? course) {
  final base = a.typeNameSnapshot ?? '成长记录';
  if (course != null) return '$base · ${course.name}';
  return base;
}

String? _achievementPaymentSubtitle(Payment? payment) {
  if (payment == null) return null;
  final parts = <String>[];
  if (payment.typeNameSnapshot != null) {
    parts.add(payment.typeNameSnapshot!);
  }
  parts.add(CreditBalanceFormatter().formatAmount(payment.amountCents));
  return parts.join(' · ');
}

String _packageSubtitle(Package p, CreditBalanceFormatter formatter) {
  final parts = <String>[];
  if (p.totalCredits != null) {
    parts.add('${formatter.formatCredits(p.totalCredits!)}课时');
  }
  if (p.amountCents != null) parts.add(formatter.formatAmount(p.amountCents));
  return parts.join(' · ');
}
