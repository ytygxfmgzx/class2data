import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'attachment_dao.g.dart';

@DriftAccessor(tables: [Attachments])
class AttachmentDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentDaoMixin {
  AttachmentDao(super.db);

  Stream<List<Attachment>> watchByOwner(String ownerType, int ownerId) {
    return (select(attachments)
          ..where(
            (t) => t.ownerType.equals(ownerType) & t.ownerId.equals(ownerId),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<Attachment>> getByOwner(String ownerType, int ownerId) {
    return (select(attachments)..where(
          (t) => t.ownerType.equals(ownerType) & t.ownerId.equals(ownerId),
        ))
        .get();
  }

  Future<Attachment?> getById(int id) {
    return (select(
      attachments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertAttachment(AttachmentsCompanion entry) {
    return into(attachments).insert(entry);
  }

  Future<void> deleteAttachment(int id) {
    return (delete(attachments)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteByOwner(String ownerType, int ownerId) {
    return (delete(attachments)..where(
          (t) => t.ownerType.equals(ownerType) & t.ownerId.equals(ownerId),
        ))
        .go();
  }

  Future<List<Attachment>> getByOwnerIds(String ownerType, List<int> ownerIds) {
    if (ownerIds.isEmpty) return Future.value([]);
    return (select(attachments)
          ..where(
            (t) => t.ownerType.equals(ownerType) & t.ownerId.isIn(ownerIds),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}
