import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 附件文件服务实例
final attachmentFileServiceProvider = Provider<AttachmentFileService>((ref) {
  return AttachmentFileService();
});

/// 监听某业务对象的附件
final attachmentsByOwnerProvider =
    StreamNotifierProvider.family<
      AttachmentsByOwnerNotifier,
      Result<List<Attachment>>,
      ({String ownerType, int ownerId})
    >(AttachmentsByOwnerNotifier.new);

class AttachmentsByOwnerNotifier
    extends
        FamilyStreamNotifier<
          Result<List<Attachment>>,
          ({String ownerType, int ownerId})
        > {
  @override
  Stream<Result<List<Attachment>>> build(
    ({String ownerType, int ownerId}) arg,
  ) {
    final repo = ref.watch(attachmentRepositoryProvider);
    return repo.watchByOwner(arg.ownerType, arg.ownerId);
  }
}
