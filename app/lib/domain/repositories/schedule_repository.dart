import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class ScheduleRepository {
  Stream<Result<List<CourseSchedule>>> watchActiveByCourseId(int courseId);
  Stream<Result<List<CourseSchedule>>> watchAllByCourseId(int courseId);
  Future<Result<CourseSchedule?>> getById(int id);
  Future<Result<int>> insertSchedule(CourseSchedulesCompanion entry);
  Future<Result<void>> updateSchedule(CourseSchedulesCompanion entry);
  Future<Result<void>> setPaused(int id, bool paused);
  Future<Result<void>> deleteSchedule(int id);
}
