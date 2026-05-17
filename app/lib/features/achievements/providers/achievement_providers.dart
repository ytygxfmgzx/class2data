import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/achievements/models/achievement_list_item.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某孩子下的成就
final achievementsByChildProvider =
    StreamNotifierProvider.family<
      AchievementsByChildNotifier,
      Result<List<Achievement>>,
      int
    >(AchievementsByChildNotifier.new);

class AchievementsByChildNotifier
    extends FamilyStreamNotifier<Result<List<Achievement>>, int> {
  @override
  Stream<Result<List<Achievement>>> build(int arg) {
    final repo = ref.watch(achievementRepositoryProvider);
    return repo.watchByChildId(arg);
  }
}

/// 监听某课程下的成就
final achievementsByCourseProvider =
    StreamNotifierProvider.family<
      AchievementsByCourseNotifier,
      Result<List<Achievement>>,
      int
    >(AchievementsByCourseNotifier.new);

class AchievementsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Achievement>>, int> {
  @override
  Stream<Result<List<Achievement>>> build(int arg) {
    final repo = ref.watch(achievementRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 根据 ID 获取单个成就
final achievementByIdProvider = FutureProvider.family<Achievement?, int>((
  ref,
  id,
) async {
  final repo = ref.watch(achievementRepositoryProvider);
  final result = await repo.getById(id);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
});

/// 课程维度成长记录列表（含类型标签和关联费用）
final achievementListItemsByCourseProvider =
    FutureProvider.family<List<AchievementListItem>, int>((
      ref,
      courseId,
    ) async {
      final asyncAchievements = ref.watch(
        achievementsByCourseProvider(courseId),
      );
      final achievements = switch (asyncAchievements) {
        AsyncData(:final value) => switch (value) {
          Ok(:final value) => value,
          Err() => <Achievement>[],
        },
        _ => <Achievement>[],
      };

      final repo = ref.read(achievementRepositoryProvider);
      final items = await Future.wait(
        achievements.map((a) async {
          final typeLinksResult = await repo.getTypeLinks(a.id);
          final typeLinks = switch (typeLinksResult) {
            Ok(:final value) => value,
            Err() => <AchievementTypeLink>[],
          };

          final paymentResult = await repo.getPaymentByAchievementId(a.id);
          final payment = switch (paymentResult) {
            Ok(:final value) => value,
            Err() => null,
          };

          return AchievementListItem(
            achievement: a,
            typeLinks: typeLinks,
            payment: payment,
          );
        }),
      );

      return items;
    });
