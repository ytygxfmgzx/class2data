import 'package:class2data/data/database/app_database.dart';

/// 课程统计数据
class CourseStatistics {
  final int classCount;
  final int totalDurationMinutes;
  final int consumedCredits;
  final int totalSpentCents;
  final int remainingCredits;
  final int purchasedCredits;
  final DateTime? firstClassDate;

  const CourseStatistics({
    this.classCount = 0,
    this.totalDurationMinutes = 0,
    this.consumedCredits = 0,
    this.totalSpentCents = 0,
    this.remainingCredits = 0,
    this.purchasedCredits = 0,
    this.firstClassDate,
  });
}

/// 时间线事件
class TimelineEvent {
  final String date;
  final String type; // class_record | achievement | package | payment
  final String title;
  final String? subtitle;
  final int? kidCourseId;
  final int? recordId;
  final int? achievementId;
  final int? packageId;

  const TimelineEvent({
    required this.date,
    required this.type,
    required this.title,
    this.subtitle,
    this.kidCourseId,
    this.recordId,
    this.achievementId,
    this.packageId,
  });
}

/// 课程统计与时间线服务。
///
/// 聚合已有的 DAO 数据，不直接访问数据库。
class CourseStatisticsService {
  /// 从原始数据计算课程统计。
  CourseStatistics computeStatistics({
    required List<ClassRecord> records,
    required List<CreditTransaction> transactions,
    required List<Payment> payments,
    List<Package> packages = const [],
  }) {
    int classCount = 0;
    int totalDuration = 0;
    int consumedCredits = 0;
    int purchasedCredits = 0;
    DateTime? firstClassDate;

    for (final r in records) {
      if (r.status == 'attended' || r.status == 'makeup') {
        classCount++;
        if (r.durationMinutes != null) {
          totalDuration += r.durationMinutes!;
        }
        final d = DateTime.tryParse(r.classDate);
        if (d != null &&
            (firstClassDate == null || d.isBefore(firstClassDate))) {
          firstClassDate = d;
        }
      }
    }

    for (final tx in transactions) {
      if (tx.creditUnitsDelta > 0) {
        purchasedCredits += tx.creditUnitsDelta;
      } else {
        consumedCredits += -tx.creditUnitsDelta;
      }
    }

    var totalSpent = payments.fold<int>(0, (sum, p) => sum + p.amountCents);
    for (final p in packages) {
      if (!p.isVoided && p.amountCents != null) {
        totalSpent += p.amountCents!;
      }
    }
    final remaining = purchasedCredits - consumedCredits;

    return CourseStatistics(
      classCount: classCount,
      totalDurationMinutes: totalDuration,
      consumedCredits: consumedCredits,
      totalSpentCents: totalSpent,
      remainingCredits: remaining,
      purchasedCredits: purchasedCredits,
      firstClassDate: firstClassDate,
    );
  }

  /// 从多种记录生成时间线事件。
  List<TimelineEvent> buildTimeline({
    List<ClassRecord> records = const [],
    List<Achievement> achievements = const [],
    List<Package> packages = const [],
  }) {
    final events = <TimelineEvent>[];

    for (final r in records) {
      final statusLabel = switch (r.status) {
        'attended' => '已上课',
        'leave' => '请假',
        'cancelled' => '取消',
        'absent' => '缺课',
        'makeup' => '补课',
        _ => r.status,
      };
      events.add(
        TimelineEvent(
          date: r.classDate,
          type: 'class_record',
          title: statusLabel,
          subtitle: r.classNameSnapshot ?? r.startTime,
          kidCourseId: r.kidCourseId,
          recordId: r.id,
        ),
      );
    }

    for (final a in achievements) {
      events.add(
        TimelineEvent(
          date: a.achievementDate,
          type: 'achievement',
          title: a.title,
          subtitle: a.description,
          kidCourseId: a.kidCourseId,
          achievementId: a.id,
        ),
      );
    }

    for (final p in packages) {
      final typeLabel = CreditBalanceFormatter().packageTypeLabel(p.type);
      events.add(
        TimelineEvent(
          date: _formatDate(p.purchaseDate),
          type: 'package',
          title: '购入 $typeLabel',
          subtitle: p.totalCredits != null
              ? '${CreditBalanceFormatter().formatCredits(p.totalCredits!)}课时'
              : null,
          kidCourseId: p.kidCourseId,
          packageId: p.id,
        ),
      );
    }

    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

/// 格式化辅助（避免循环依赖 CreditBalanceService）
class CreditBalanceFormatter {
  String formatCredits(int creditUnits) {
    if (creditUnits % 100 == 0) return '${creditUnits ~/ 100}';
    return '${creditUnits / 100}';
  }

  String formatAmount(int? amountCents) {
    if (amountCents == null) return '--';
    if (amountCents % 100 == 0) return '¥${amountCents ~/ 100}';
    return '¥${(amountCents / 100).toStringAsFixed(2)}';
  }

  String packageTypeLabel(String type) {
    return switch (type) {
      'lesson_pack' => '课时包',
      'trial_pack' => '体验包',
      'gift_pack' => '赠课包',
      'period_pack' => '周期卡',
      _ => type,
    };
  }
}
