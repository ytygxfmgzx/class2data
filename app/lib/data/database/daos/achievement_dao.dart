import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'achievement_dao.g.dart';

@DriftAccessor(tables: [Achievements])
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

  Future<int> insertAchievement(AchievementsCompanion entry) {
    return into(achievements).insert(entry);
  }

  Future<void> updateAchievement(AchievementsCompanion entry) {
    return (update(
      achievements,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  Future<void> deleteAchievement(int id) {
    return (delete(achievements)..where((t) => t.id.equals(id))).go();
  }
}
