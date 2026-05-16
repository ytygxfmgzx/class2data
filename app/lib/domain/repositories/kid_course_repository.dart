import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class KidCourseRepository {
  Stream<Result<List<KidCourse>>> watchByChildId(int childId);
  Stream<Result<List<KidCourse>>> watchAllActive();
  Future<Result<KidCourse?>> getById(int id);
  Future<Result<int>> insertCourse(KidCoursesCompanion entry);
  Future<Result<void>> updateCourse(KidCoursesCompanion entry);
  Future<Result<void>> archiveCourse(int id);
  Future<Result<void>> deleteCourse(int id);
}
