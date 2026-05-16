import 'package:class2data/data/database/app_database.dart';

class CreditBalanceService {
  /// 计算课包余额：sum(credit_units_delta where package_id)
  int packageBalance(List<CreditTransaction> transactions) {
    return transactions.fold(0, (sum, tx) => sum + tx.creditUnitsDelta);
  }

  /// 计算课程总余额：sum(credit_units_delta where kid_course_id)
  int courseBalance(List<CreditTransaction> transactions) {
    return transactions.fold(0, (sum, tx) => sum + tx.creditUnitsDelta);
  }

  /// 格式化课时：100 → "1", 150 → "1.5", 0 → "0"
  String formatCredits(int creditUnits) {
    if (creditUnits % 100 == 0) {
      return '${creditUnits ~/ 100}';
    }
    return '${creditUnits / 100}';
  }

  /// 格式化金额（分 → 元）
  String formatAmount(int? amountCents) {
    if (amountCents == null) return '--';
    if (amountCents % 100 == 0) {
      return '¥${amountCents ~/ 100}';
    }
    return '¥${(amountCents / 100).toStringAsFixed(2)}';
  }

  /// 课包类型显示名
  String packageTypeLabel(String type) {
    return switch (type) {
      'lesson_pack' => '课时包',
      'trial_pack' => '体验包',
      'gift_pack' => '赠课包',
      'period_pack' => '周期卡',
      _ => type,
    };
  }

  /// 周期卡当前状态：按本地日期比较，有效期首尾日都视为进行中。
  String periodPackageStatusLabel({
    required DateTime now,
    DateTime? validFrom,
    DateTime? validUntil,
  }) {
    final today = _dateOnly(now);
    if (validFrom != null && today.isBefore(_dateOnly(validFrom))) {
      return '未开始';
    }
    if (validUntil != null && today.isAfter(_dateOnly(validUntil))) {
      return '已结束';
    }
    return '进行中';
  }

  /// 周期卡有效期展示。
  String periodPackageValidityLabel(DateTime? validFrom, DateTime? validUntil) {
    if (validFrom != null && validUntil != null) {
      return '${formatDate(validFrom)} 至 ${formatDate(validUntil)}';
    }
    if (validFrom != null) {
      return '${formatDate(validFrom)} 起';
    }
    if (validUntil != null) {
      return '截至 ${formatDate(validUntil)}';
    }
    return '未设置有效期';
  }

  String formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  /// 流水类型显示名
  String transactionTypeLabel(String type) {
    return switch (type) {
      'purchase' => '购入',
      'consume' => '消耗',
      'adjust' => '调整',
      'refund' => '退款',
      'void' => '作废',
      'pending' => '待确认',
      _ => type,
    };
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
