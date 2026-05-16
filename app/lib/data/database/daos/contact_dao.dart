import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'contact_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactDao extends DatabaseAccessor<AppDatabase> with _$ContactDaoMixin {
  ContactDao(super.db);

  /// 某门课程下所有联系人
  Future<List<Contact>> getByCourseId(int courseId) {
    return (select(contacts)
          ..where((t) => t.kidCourseId.equals(courseId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// 监听某门课程下所有联系人
  Stream<List<Contact>> watchByCourseId(int courseId) {
    return (select(contacts)
          ..where((t) => t.kidCourseId.equals(courseId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  /// 单个联系人
  Future<Contact?> getById(int id) {
    return (select(contacts)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 新增联系人
  Future<int> insertContact(ContactsCompanion entry) {
    return into(contacts).insert(entry);
  }

  /// 更新联系人
  Future<void> updateContact(ContactsCompanion entry) {
    return (update(
      contacts,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }

  /// 删除联系人
  Future<void> deleteContact(int id) {
    return (delete(contacts)..where((t) => t.id.equals(id))).go();
  }
}
