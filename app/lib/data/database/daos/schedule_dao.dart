import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'schedule_dao.g.dart';

@DriftAccessor(tables: [CourseSchedules])
class ScheduleDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduleDaoMixin {
  ScheduleDao(super.db);

  /// 某门课程下所有未暂停的计划
  Stream<List<CourseSchedule>> watchActiveByCourseId(int courseId) {
    return (select(courseSchedules)
          ..where((t) => t.kidCourseId.equals(courseId))
          ..where((t) => t.isPaused.equals(false)))
        .watch();
  }

  /// 某门课程下所有计划（含暂停）
  Stream<List<CourseSchedule>> watchAllByCourseId(int courseId) {
    return (select(courseSchedules)
          ..where((t) => t.kidCourseId.equals(courseId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// 单个计划
  Future<CourseSchedule?> getById(int id) {
    return (select(
      courseSchedules,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 新增计划
  Future<int> insertSchedule(CourseSchedulesCompanion entry) {
    return into(courseSchedules).insert(entry);
  }

  /// 更新计划
  Future<void> updateSchedule(CourseSchedulesCompanion entry) {
    return (update(
      courseSchedules,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  /// 暂停/恢复计划
  Future<void> setPaused(int id, bool paused) {
    return (update(courseSchedules)..where((t) => t.id.equals(id))).write(
      CourseSchedulesCompanion(
        isPaused: Value(paused),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除计划（仅草稿，无关联记录时使用）
  Future<void> deleteSchedule(int id) {
    return (delete(courseSchedules)..where((t) => t.id.equals(id))).go();
  }
}
