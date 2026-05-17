import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'child_dao.g.dart';

@DriftAccessor(
  tables: [
    Children,
    KidCourses,
    CourseSchedules,
    Packages,
    ClassRecords,
    CreditTransactions,
    Payments,
    Achievements,
    AchievementTypeLinks,
    Attachments,
    Contacts,
  ],
)
class ChildDao extends DatabaseAccessor<AppDatabase> with _$ChildDaoMixin {
  ChildDao(super.db);

  /// 所有未归档的孩子，按创建时间排序
  Future<List<ChildrenData>> getAllActive() {
    return (select(children)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// 监听所有未归档的孩子
  Stream<List<ChildrenData>> watchAllActive() {
    return (select(children)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// 单个孩子
  Future<ChildrenData?> getById(int id) {
    return (select(children)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 新增孩子
  Future<int> insertChild(ChildrenCompanion entry) {
    return into(children).insert(entry);
  }

  /// 更新孩子
  Future<void> updateChild(ChildrenCompanion entry) {
    return (update(
      children,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  /// 查询孩子的附件路径（用于删除物理文件）
  Future<List<String>> getAttachmentPathsForChild(int childId) async {
    final courseRows = await (select(
      kidCourses,
    )..where((t) => t.childId.equals(childId))).get();
    final courseIds = courseRows.map((c) => c.id).toList();

    final paths = <String>[];

    // 课程的附件
    if (courseIds.isNotEmpty) {
      final courseAttachments =
          await (select(attachments)..where(
                (t) => t.ownerType.equals('course') & t.ownerId.isIn(courseIds),
              ))
              .get();
      paths.addAll(courseAttachments.map((a) => a.relativePath));
    }

    // 课包的附件
    if (courseIds.isNotEmpty) {
      final packageRows = await (select(
        packages,
      )..where((t) => t.kidCourseId.isIn(courseIds))).get();
      final packageIds = packageRows.map((p) => p.id).toList();
      if (packageIds.isNotEmpty) {
        final pkgAttachments =
            await (select(attachments)..where(
                  (t) =>
                      t.ownerType.equals('package') &
                      t.ownerId.isIn(packageIds),
                ))
                .get();
        paths.addAll(pkgAttachments.map((a) => a.relativePath));
      }

      // 上课记录的附件
      final recordRows = await (select(
        classRecords,
      )..where((t) => t.kidCourseId.isIn(courseIds))).get();
      final recordIds = recordRows.map((r) => r.id).toList();
      if (recordIds.isNotEmpty) {
        final recAttachments =
            await (select(attachments)..where(
                  (t) =>
                      t.ownerType.equals('class_record') &
                      t.ownerId.isIn(recordIds),
                ))
                .get();
        paths.addAll(recAttachments.map((a) => a.relativePath));
      }
    }

    // 成就的附件
    final achievementRows = await (select(
      achievements,
    )..where((t) => t.childId.equals(childId))).get();
    final achievementIds = achievementRows.map((a) => a.id).toList();
    if (achievementIds.isNotEmpty) {
      final achAttachments =
          await (select(attachments)..where(
                (t) =>
                    t.ownerType.equals('achievement') &
                    t.ownerId.isIn(achievementIds),
              ))
              .get();
      paths.addAll(achAttachments.map((a) => a.relativePath));
    }

    return paths;
  }

  /// 级联删除孩子及所有关联数据
  Future<void> deleteChildCascade(int childId) async {
    await transaction(() async {
      // 查找该孩子的所有课程 ID
      final courseRows = await (select(
        kidCourses,
      )..where((t) => t.childId.equals(childId))).get();
      final courseIds = courseRows.map((c) => c.id).toList();

      if (courseIds.isNotEmpty) {
        // 删除附件（上课记录、课包、课程维度）
        final recordRows = await (select(
          classRecords,
        )..where((t) => t.kidCourseId.isIn(courseIds))).get();
        final recordIds = recordRows.map((r) => r.id).toList();
        if (recordIds.isNotEmpty) {
          await (delete(attachments)..where(
                (t) =>
                    t.ownerType.equals('class_record') &
                    t.ownerId.isIn(recordIds),
              ))
              .go();
        }

        final packageRows = await (select(
          packages,
        )..where((t) => t.kidCourseId.isIn(courseIds))).get();
        final packageIds = packageRows.map((p) => p.id).toList();
        if (packageIds.isNotEmpty) {
          await (delete(attachments)..where(
                (t) =>
                    t.ownerType.equals('package') & t.ownerId.isIn(packageIds),
              ))
              .go();
        }

        await (delete(attachments)..where(
              (t) => t.ownerType.equals('course') & t.ownerId.isIn(courseIds),
            ))
            .go();

        // 按外键依赖顺序删除：先删叶子表
        await (delete(
          creditTransactions,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
        await (delete(
          payments,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
        await (delete(
          classRecords,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
        await (delete(
          courseSchedules,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
        await (delete(
          packages,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
        await (delete(
          contacts,
        )..where((t) => t.kidCourseId.isIn(courseIds))).go();
      }

      // 成就附件 → 成就
      final achievementRows = await (select(
        achievements,
      )..where((t) => t.childId.equals(childId))).get();
      final achievementIds = achievementRows.map((a) => a.id).toList();
      if (achievementIds.isNotEmpty) {
        await (delete(attachments)..where(
              (t) =>
                  t.ownerType.equals('achievement') &
                  t.ownerId.isIn(achievementIds),
            ))
            .go();
        await (delete(
          achievementTypeLinks,
        )..where((t) => t.achievementId.isIn(achievementIds))).go();
      }
      await (delete(
        achievements,
      )..where((t) => t.childId.equals(childId))).go();

      // 课程 → 孩子
      await (delete(kidCourses)..where((t) => t.childId.equals(childId))).go();
      await (delete(children)..where((t) => t.id.equals(childId))).go();
    });
  }

  /// 删除孩子（不带级联）
  Future<void> deleteChild(int id) {
    return (delete(children)..where((t) => t.id.equals(id))).go();
  }
}
