import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/photo_viewer.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentListSection extends ConsumerWidget {
  final String ownerType;
  final int ownerId;
  final void Function(int index, List<Attachment> attachments)? onPhotoTap;

  const AttachmentListSection({
    super.key,
    required this.ownerType,
    required this.ownerId,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachmentsAsync = ref.watch(
      attachmentsByOwnerProvider((ownerType: ownerType, ownerId: ownerId)),
    );
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '照片',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _pickImage(context, ref),
                child: const Text('添加照片'),
              ),
            ],
          ),
        ),
        attachmentsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('加载失败: $e'),
          ),
          data: (result) => switch (result) {
            Ok(:final value) =>
              value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '暂无照片',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : _AttachmentGrid(
                      attachments: value,
                      ownerType: ownerType,
                      ownerId: ownerId,
                      onPhotoTap: onPhotoTap,
                    ),
            Err(:final error) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(error.message),
            ),
          },
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    final List<XFile> selectedFiles;
    if (source == ImageSource.camera) {
      final xFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFile == null) return;
      selectedFiles = [xFile];
    } else {
      selectedFiles = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (selectedFiles.isEmpty) return;
    }

    final fileService = ref.read(attachmentFileServiceProvider);
    final repo = ref.read(attachmentRepositoryProvider);

    for (final xFile in selectedFiles) {
      try {
        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: xFile.path,
          ownerType: ownerType,
          ownerId: ownerId,
        );

        final originalName = xFile.name;
        final fileSize = await File(xFile.path).length();

        await repo.insertAttachment(
          AttachmentsCompanion(
            ownerType: Value(ownerType),
            ownerId: Value(ownerId),
            fileType: const Value('photo'),
            originalFileName: Value(originalName),
            relativePath: Value(relativePath),
            fileSizeBytes: Value(fileSize),
            mimeType: Value(xFile.mimeType),
            createdAt: Value(DateTime.now()),
          ),
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('添加附件失败: $e')));
        }
      }
    }
  }
}

class _AttachmentGrid extends ConsumerWidget {
  final List<Attachment> attachments;
  final String ownerType;
  final int ownerId;
  final void Function(int index, List<Attachment> attachments)? onPhotoTap;

  const _AttachmentGrid({
    required this.attachments,
    required this.ownerType,
    required this.ownerId,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 8.0;
          final itemSize = (constraints.maxWidth - spacing * 2) / 3;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: attachments.indexed.map((entry) {
              final index = entry.$1;
              final attachment = entry.$2;
              return _AttachmentThumb(
                attachment: attachment,
                size: itemSize,
                onTap: onPhotoTap != null
                    ? () => onPhotoTap!(index, attachments)
                    : null,
                onDelete: () => _deleteAttachment(context, ref, attachment),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _deleteAttachment(
    BuildContext context,
    WidgetRef ref,
    Attachment attachment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除照片'),
        content: const Text('确定删除这张照片？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final fileService = ref.read(attachmentFileServiceProvider);
    final repo = ref.read(attachmentRepositoryProvider);

    final deleted = await fileService.deleteFile(attachment.relativePath);
    if (deleted) {
      await repo.deleteAttachment(attachment.id);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('文件删除失败，请重试')));
      }
    }
  }
}

class _AttachmentThumb extends StatelessWidget {
  final Attachment attachment;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const _AttachmentThumb({
    required this.attachment,
    required this.size,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap ?? () => _openViewer(context),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _buildContent(context),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openViewer(BuildContext context) async {
    final absPath = await AttachmentFileService().getAbsolutePath(
      attachment.relativePath,
    );
    if (context.mounted) {
      await PhotoViewerDialog.show(context, imagePaths: [absPath]);
    }
  }

  Widget _buildContent(BuildContext context) {
    if (attachment.fileType == 'photo') {
      return FutureBuilder<String>(
        future: AttachmentFileService().getAbsolutePath(
          attachment.relativePath,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final file = File(snapshot.data!);
            if (file.existsSync()) {
              return Image.file(file, fit: BoxFit.cover);
            }
          }
          return const Center(child: Icon(Icons.broken_image, size: 24));
        },
      );
    }
    return Center(
      child: Icon(
        Icons.insert_drive_file,
        size: 24,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
