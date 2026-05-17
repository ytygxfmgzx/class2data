import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'achievement_dao.g.dart';

@DriftAccessor(
  tables: [Achievements, AchievementTypeLinks, Payments, Attachments],
)
class AchievementDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementDaoMixin {
  AchievementDao(super.db);

  Stream<List<Achievement>> watchByChildId(int childId) {
    return (select(achievements)
          ..where((t) => t.childId.equals(childId))
          ..orderBy([(t) => OrderingTerm.desc(t.achievementDate)]))
        .watch();
  }

  Stream<List<Achievement>> watchByCourseId(int kidCourseId) {
    return (select(achievements)
          ..where((t) => t.kidCourseId.equals(kidCourseId))
          ..orderBy([(t) => OrderingTerm.desc(t.achievementDate)]))
        .watch();
  }

  Future<Achievement?> getById(int id) {
    return (select(
      achievements,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<AchievementTypeLink>> getTypeLinks(int achievementId) {
    return (select(achievementTypeLinks)
          ..where((t) => t.achievementId.equals(achievementId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<Payment?> getPaymentByAchievementId(int achievementId) {
    return (select(
      payments,
    )..where((t) => t.achievementId.equals(achievementId))).getSingleOrNull();
  }

  Future<int> insertAchievement(AchievementsCompanion entry) {
    return into(achievements).insert(entry);
  }

  Future<void> updateAchievement(AchievementsCompanion entry) {
    return (update(
      achievements,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> deleteAchievement(int id) {
    return transaction(() async {
      await (delete(
        achievementTypeLinks,
      )..where((t) => t.achievementId.equals(id))).go();
      await (delete(payments)..where((t) => t.achievementId.equals(id))).go();
      await (delete(attachments)..where(
            (t) => t.ownerType.equals('achievement') & t.ownerId.equals(id),
          ))
          .go();
      await (delete(achievements)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<int> saveAchievementBundle({
    required AchievementsCompanion achievement,
    required List<AchievementTypeLinksCompanion> typeLinks,
    PaymentsCompanion? payment,
  }) {
    return transaction(() async {
      final achievementId = achievement.id.present
          ? achievement.id.value
          : await into(achievements).insert(achievement);

      if (achievement.id.present) {
        await (update(
          achievements,
        )..where((t) => t.id.equals(achievementId))).write(achievement);
      }

      await (delete(
        achievementTypeLinks,
      )..where((t) => t.achievementId.equals(achievementId))).go();
      for (final link in typeLinks) {
        await into(
          achievementTypeLinks,
        ).insert(link.copyWith(achievementId: Value(achievementId)));
      }

      final existingPayment = await getPaymentByAchievementId(achievementId);
      if (payment == null) {
        if (existingPayment != null) {
          await (delete(
            payments,
          )..where((t) => t.id.equals(existingPayment.id))).go();
        }
      } else if (existingPayment != null) {
        await (update(
          payments,
        )..where((t) => t.id.equals(existingPayment.id))).write(
          payment.copyWith(
            id: Value(existingPayment.id),
            achievementId: Value(achievementId),
            createdAt: Value(existingPayment.createdAt),
          ),
        );
      } else {
        await into(
          payments,
        ).insert(payment.copyWith(achievementId: Value(achievementId)));
      }

      return achievementId;
    });
  }
}
