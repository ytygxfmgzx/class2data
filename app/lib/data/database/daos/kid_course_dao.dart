import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'kid_course_dao.g.dart';

@DriftAccessor(tables: [KidCourses])
class KidCourseDao extends DatabaseAccessor<AppDatabase>
    with _$KidCourseDaoMixin {
  KidCourseDao(super.db);

  /// 某个孩子下所有未归档课程
  Future<List<KidCourse>> getByChildId(int childId) {
    return (select(kidCourses)
          ..where((t) => t.childId.equals(childId))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// 监听某个孩子下所有未归档课程
  Stream<List<KidCourse>> watchByChildId(int childId) {
    return (select(kidCourses)
          ..where((t) => t.childId.equals(childId))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// 所有未归档课程
  Stream<List<KidCourse>> watchAllActive() {
    return (select(kidCourses)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// 单个课程
  Future<KidCourse?> getById(int id) {
    return (select(
      kidCourses,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 新增课程
  Future<int> insertCourse(KidCoursesCompanion entry) {
    return into(kidCourses).insert(entry);
  }

  /// 更新课程
  Future<void> updateCourse(KidCoursesCompanion entry) {
    return (update(
      kidCourses,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  /// 归档课程
  Future<void> archiveCourse(int id) {
    return (update(kidCourses)..where((t) => t.id.equals(id))).write(
      KidCoursesCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除课程（级联清理关联数据）
  Future<void> deleteCourse(int id) async {
    final db = attachedDatabase;
    await transaction(() async {
      // 附件：通过 class_records / packages 间接关联
      final recordIds = await (select(
        db.classRecords,
      )..where((t) => t.kidCourseId.equals(id))).map((r) => r.id).get();
      final packageIds = await (select(
        db.packages,
      )..where((t) => t.kidCourseId.equals(id))).map((p) => p.id).get();

      for (final rid in recordIds) {
        await (delete(db.attachments)..where(
              (t) => t.ownerType.equals('class_record') & t.ownerId.equals(rid),
            ))
            .go();
      }
      for (final pid in packageIds) {
        await (delete(db.attachments)..where(
              (t) => t.ownerType.equals('package') & t.ownerId.equals(pid),
            ))
            .go();
      }

      // 按外键依赖顺序删除
      await (delete(
        db.creditTransactions,
      )..where((t) => t.kidCourseId.equals(id))).go();
      await (delete(db.payments)..where((t) => t.kidCourseId.equals(id))).go();
      await (delete(
        db.classRecords,
      )..where((t) => t.kidCourseId.equals(id))).go();
      await (delete(db.packages)..where((t) => t.kidCourseId.equals(id))).go();
      await (delete(db.contacts)..where((t) => t.kidCourseId.equals(id))).go();
      await (delete(
        db.courseSchedules,
      )..where((t) => t.kidCourseId.equals(id))).go();

      // 成就的 kidCourseId 是 nullable，只清除关联
      await (update(db.achievements)..where((t) => t.kidCourseId.equals(id)))
          .write(const AchievementsCompanion(kidCourseId: Value(null)));

      // 最后删课程本身
      await (delete(kidCourses)..where((t) => t.id.equals(id))).go();
    });
  }
}
