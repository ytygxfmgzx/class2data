import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/achievements/providers/achievement_providers.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/class_records/providers/class_record_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 照片墙条目
class PhotoEntry {
  final Attachment attachment;
  final String? absolutePath;
  final String ownerLabel;

  const PhotoEntry({
    required this.attachment,
    this.absolutePath,
    required this.ownerLabel,
  });
}

/// 某孩子的所有照片
final childPhotosProvider = FutureProvider.family<List<PhotoEntry>, int>((
  ref,
  childId,
) async {
  final fileService = ref.watch(attachmentFileServiceProvider);
  final repo = ref.watch(attachmentRepositoryProvider);

  // 获取孩子所有课程
  final coursesResult = await ref.watch(coursesByChildProvider(childId).future);
  final courses = switch (coursesResult) {
    Ok(:final value) => value,
    Err() => <KidCourse>[],
  };

  // 收集上课记录 ID
  final recordIds = <int>[];
  for (final course in courses) {
    final recordsResult = await ref.watch(
      classRecordsByCourseProvider(course.id).future,
    );
    final records = switch (recordsResult) {
      Ok(:final value) => value,
      Err() => <ClassRecord>[],
    };
    recordIds.addAll(records.map((r) => r.id));
  }

  // 收集成就 ID
  final achievementsResult = await ref.watch(
    achievementsByChildProvider(childId).future,
  );
  final achievements = switch (achievementsResult) {
    Ok(:final value) => value,
    Err() => <Achievement>[],
  };
  final achievementIds = achievements.map((a) => a.id).toList();

  // 查询附件
  final photos = <PhotoEntry>[];

  final recordAttachmentsResult = await repo.getByOwnerIds(
    'class_record',
    recordIds,
  );
  final recordAttachments = switch (recordAttachmentsResult) {
    Ok(:final value) => value,
    Err() => <Attachment>[],
  };
  for (final a in recordAttachments) {
    photos.add(
      PhotoEntry(
        attachment: a,
        absolutePath: await fileService.getAbsolutePath(a.relativePath),
        ownerLabel: '上课记录',
      ),
    );
  }

  final achievementAttachmentsResult = await repo.getByOwnerIds(
    'achievement',
    achievementIds,
  );
  final achievementAttachments = switch (achievementAttachmentsResult) {
    Ok(:final value) => value,
    Err() => <Attachment>[],
  };
  for (final a in achievementAttachments) {
    photos.add(
      PhotoEntry(
        attachment: a,
        absolutePath: await fileService.getAbsolutePath(a.relativePath),
        ownerLabel: '成就',
      ),
    );
  }

  // 按创建时间倒序
  photos.sort(
    (a, b) => b.attachment.createdAt.compareTo(a.attachment.createdAt),
  );
  return photos;
});
