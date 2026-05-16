import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class AttachmentRepository {
  Stream<Result<List<Attachment>>> watchByOwner(String ownerType, int ownerId);
  Future<Result<List<Attachment>>> getByOwner(String ownerType, int ownerId);
  Future<Result<List<Attachment>>> getByOwnerIds(
    String ownerType,
    List<int> ownerIds,
  );
  Future<Result<Attachment?>> getById(int id);
  Future<Result<int>> insertAttachment(AttachmentsCompanion entry);
  Future<Result<void>> deleteAttachment(int id);
  Future<Result<void>> deleteByOwner(String ownerType, int ownerId);
}
