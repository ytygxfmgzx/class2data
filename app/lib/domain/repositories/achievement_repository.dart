import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class AchievementRepository {
  Stream<Result<List<Achievement>>> watchByChildId(int childId);
  Stream<Result<List<Achievement>>> watchByCourseId(int kidCourseId);
  Future<Result<Achievement?>> getById(int id);
  Future<Result<int>> insertAchievement(AchievementsCompanion entry);
  Future<Result<void>> updateAchievement(AchievementsCompanion entry);
  Future<Result<void>> deleteAchievement(int id);
}
