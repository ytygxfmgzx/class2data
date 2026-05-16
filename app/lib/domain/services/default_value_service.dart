import 'package:class2data/data/database/app_database.dart';

/// 上课记录默认值
class ClassRecordDefaults {
  final int? creditUnitsCost;
  final int? durationMinutes;
  final int? packageId;

  const ClassRecordDefaults({
    this.creditUnitsCost,
    this.durationMinutes,
    this.packageId,
  });
}

/// 默认值带出服务。
///
/// 按优先级从历史记录和课程设置中带出默认值。
class DefaultValueService {
  /// 获取上课记录的默认值。
  ///
  /// 优先级：
  /// 1. 最近一次同课程、同上课类型的记录
  /// 2. 最近一次同课程记录
  /// 3. KidCourse.defaultCreditUnitsCost 和 defaultDurationMinutes
  ClassRecordDefaults getDefaults({
    required List<ClassRecord> historyRecords,
    required KidCourse course,
    String? classType,
  }) {
    // 优先级 1：最近一次同课程、同上课类型
    ClassRecord? match;
    if (classType != null) {
      for (final r in historyRecords.reversed) {
        if (r.classType == classType) {
          match = r;
          break;
        }
      }
    }

    // 优先级 2：最近一次同课程
    match ??= historyRecords.isNotEmpty ? historyRecords.last : null;

    return ClassRecordDefaults(
      creditUnitsCost: match?.creditUnitsCost ?? course.defaultCreditUnitsCost,
      durationMinutes: match?.durationMinutes ?? course.defaultDurationMinutes,
      packageId: match?.packageId,
    );
  }
}
