import 'package:class2data/data/database/app_database.dart';

/// 课包自动推荐服务。
///
/// 在当前课程范围内推荐最合适的可用课包。
class PackageSelectionService {
  /// 从可用课包中推荐一个最合适的。
  ///
  /// [packages] — 当前课程下所有未作废的课包
  /// [classRecords] — 同课程历史上课记录（用于排序偏好）
  /// [classDate] — 上课日期（YYYY-MM-DD），用于排除生效日期晚的课包
  /// [packageBalances] — 课包余额（packageId → 余额，单位：credit_units，整数），
  ///   用于排除已用完的课包；为 null 时不做余额过滤
  int? recommendPackage({
    required List<Package> packages,
    required List<ClassRecord> classRecords,
    required String classDate,
    Map<int, int>? packageBalances,
  }) {
    // 候选过滤：仅保留在该上课日期有效的课包
    final candidates = packages.where((p) {
      if (p.isVoided) return false;
      final date = DateTime.parse(classDate);
      if (p.validFrom != null && date.isBefore(p.validFrom!)) return false;
      if (p.validUntil != null && date.isAfter(p.validUntil!)) return false;
      return true;
    }).toList();

    if (candidates.isEmpty) return null;

    // 排除已用完的课包（从候选中移除，但保留为备选）
    final available = <Package>[];
    final usedUp = <Package>[];
    for (final p in candidates) {
      if (p.totalCredits == null) {
        // 周期卡/不限次，视为可用
        available.add(p);
      } else if (packageBalances != null) {
        final balance = packageBalances[p.id];
        if (balance != null && balance <= 0) {
          usedUp.add(p);
        } else {
          available.add(p);
        }
      } else {
        available.add(p);
      }
    }

    if (available.isEmpty && usedUp.isEmpty) return null;
    final fromUsedUp = available.isEmpty;
    final pool = fromUsedUp ? usedUp : available;

    // 排序规则
    // 1. 最近一次同课程使用过的课包优先
    final recentPackageIds = <int>[];
    for (final r in classRecords.reversed) {
      if (r.packageId != null && !recentPackageIds.contains(r.packageId)) {
        recentPackageIds.add(r.packageId!);
      }
    }

    // 按最近使用排序
    pool.sort((a, b) {
      final aIdx = recentPackageIds.indexOf(a.id);
      final bIdx = recentPackageIds.indexOf(b.id);
      if (aIdx != -1 && bIdx != -1) return aIdx.compareTo(bIdx);
      if (aIdx != -1) return -1;
      if (bIdx != -1) return 1;
      if (fromUsedUp) {
        // 已用完池：更晚购买的优先（用户更可能续费/记录到最新课包）
        return b.purchaseDate.compareTo(a.purchaseDate);
      }
      // 可用池：更早购买的优先
      return a.purchaseDate.compareTo(b.purchaseDate);
    });

    return pool.first.id;
  }
}
