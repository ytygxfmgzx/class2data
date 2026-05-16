import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AchievementFormPage extends ConsumerStatefulWidget {
  final int childId;
  final int? courseId;
  final int? achievementId;

  const AchievementFormPage({
    super.key,
    required this.childId,
    this.courseId,
    this.achievementId,
  });

  @override
  ConsumerState<AchievementFormPage> createState() =>
      _AchievementFormPageState();
}

class _AchievementFormPageState extends ConsumerState<AchievementFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime _achievementDate = DateTime.now();
  bool _isLoading = false;
  final List<String> _pendingPhotos = [];
  final List<String> _existingPhotos = [];
  final List<int> _existingPhotoIds = [];
  final List<int> _removedAttachmentIds = [];
  int? _selectedCourseId;

  bool get _isEditing => widget.achievementId != null;

  @override
  void initState() {
    super.initState();
    _selectedCourseId = widget.courseId;
    if (_isEditing) _loadAchievement();
  }

  Future<void> _loadAchievement() async {
    final repo = ref.read(achievementRepositoryProvider);
    final result = await repo.getById(widget.achievementId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _notesController.text = value.notes ?? value.description ?? '';
            _achievementDate =
                DateTime.tryParse(value.achievementDate) ?? DateTime.now();
          });
          await _loadExistingPhotos();
        }
      case Err():
        break;
    }
  }

  Future<void> _loadExistingPhotos() async {
    if (widget.achievementId == null) return;
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);
    final result = await attachRepo.getByOwnerIds('achievement', [
      widget.achievementId!,
    ]);
    final attachments = switch (result) {
      Ok(:final value) => value,
      Err() => <Attachment>[],
    };
    final paths = <String>[];
    final ids = <int>[];
    for (final a in attachments) {
      final path = await fileService.getAbsolutePath(a.relativePath);
      if (File(path).existsSync()) {
        paths.add(path);
        ids.add(a.id);
      }
    }
    if (mounted && paths.isNotEmpty) {
      setState(() {
        _existingPhotos.addAll(paths);
        _existingPhotoIds.addAll(ids);
      });
    }
  }

  Future<void> _removeExistingPhoto(int index) async {
    final attachId = _existingPhotoIds[index];
    final attachRepo = ref.read(attachmentRepositoryProvider);
    await attachRepo.deleteAttachment(attachId);
    if (mounted) {
      setState(() {
        _existingPhotos.removeAt(index);
        _existingPhotoIds.removeAt(index);
        _removedAttachmentIds.add(attachId);
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(achievementRepositoryProvider);
    final now = DateTime.now();
    final notesText = _notesController.text.trim();
    final autoTitle = notesText.isNotEmpty
        ? (notesText.length > 200 ? notesText.substring(0, 200) : notesText)
        : '成就记录';

    final entry = AchievementsCompanion(
      id: _isEditing ? Value(widget.achievementId!) : const Value.absent(),
      childId: Value(widget.childId),
      kidCourseId: Value(_selectedCourseId),
      title: Value(autoTitle),
      description: const Value.absent(),
      achievementDate: Value(_formatDate(_achievementDate)),
      notes: Value(notesText.isNotEmpty ? notesText : null),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    int? savedId;
    if (_isEditing) {
      await repo.updateAchievement(entry);
      savedId = widget.achievementId;
    } else {
      final result = await repo.insertAchievement(entry);
      savedId = switch (result) {
        Ok(:final value) => value,
        Err() => null,
      };
    }

    if (_pendingPhotos.isNotEmpty && savedId != null) {
      await _saveAttachments(savedId);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  Future<void> _showImageSourceActionSheet() async {
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
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (xFile == null) return;

    setState(() {
      _pendingPhotos.add(xFile.path);
    });
  }

  Future<void> _saveAttachments(int achievementId) async {
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);

    for (final photoPath in _pendingPhotos) {
      try {
        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: photoPath,
          ownerType: 'achievement',
          ownerId: achievementId,
        );
        final file = File(photoPath);
        final fileName = photoPath.split('/').last.split('\\').last;
        final fileSize = await file.length();

        await attachRepo.insertAttachment(
          AttachmentsCompanion(
            ownerType: const Value('achievement'),
            ownerId: Value(achievementId),
            fileType: const Value('photo'),
            originalFileName: Value(fileName),
            relativePath: Value(relativePath),
            fileSizeBytes: Value(fileSize),
            createdAt: Value(DateTime.now()),
          ),
        );
      } catch (_) {
        // 附件保存失败不阻塞主流程
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑成就' : '录入成就'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 孩子信息展示
            _ChildInfoBanner(childId: widget.childId),
            const SizedBox(height: 16),

            // 关联课程（非必选）
            _CourseSelector(
              childId: widget.childId,
              selectedCourseId: _selectedCourseId,
              onChanged: (id) => setState(() => _selectedCourseId = id),
            ),
            const SizedBox(height: 16),

            const _Label(label: '日期'),
            const SizedBox(height: 4),
            _DateField(
              date: _achievementDate,
              onPicked: (d) => setState(() => _achievementDate = d),
            ),
            const SizedBox(height: 16),

            const _Label(label: '备注'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '记录孩子成长的精彩瞬间',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const _Label(label: '照片'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._existingPhotos.indexed.map((entry) {
                  final index = entry.$1;
                  final path = entry.$2;
                  return _PendingPhotoThumb(
                    path: path,
                    onRemove: () => _removeExistingPhoto(index),
                  );
                }),
                ..._pendingPhotos.indexed.map((entry) {
                  final index = entry.$1;
                  final path = entry.$2;
                  return _PendingPhotoThumb(
                    path: path,
                    onRemove: () =>
                        setState(() => _pendingPhotos.removeAt(index)),
                  );
                }),
                _AddPhotoButton(
                  onTap: _isLoading ? null : _showImageSourceActionSheet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

class _Label extends StatelessWidget {
  final String label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onPicked;

  const _DateField({required this.date, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final text =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (d != null) onPicked(d);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Text(text),
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddPhotoButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              '添加照片',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingPhotoThumb extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _PendingPhotoThumb({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const Center(child: Icon(Icons.broken_image, size: 24)),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onRemove,
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
}

class _ChildInfoBanner extends ConsumerWidget {
  final int childId;

  const _ChildInfoBanner({required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childAsync = ref.watch(childByIdProvider(childId));
    final theme = Theme.of(context);

    return childAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (child) {
        if (child == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              ChildAvatar(
                name: child.name,
                avatarPath: child.avatarPath,
                radius: 18,
              ),
              const SizedBox(width: 10),
              Text(
                child.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '成就归属',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CourseSelector extends ConsumerWidget {
  final int childId;
  final int? selectedCourseId;
  final ValueChanged<int?> onChanged;

  const _CourseSelector({
    required this.childId,
    required this.selectedCourseId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesByChildProvider(childId));

    return coursesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (result) {
        final courses = switch (result) {
          Ok(:final value) => value,
          Err() => <KidCourse>[],
        };
        if (courses.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '关联课程（可选）',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<int>(
              initialValue: selectedCourseId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '选择课程',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: [
                const DropdownMenuItem<int>(value: null, child: Text('不关联')),
                ...courses.map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: onChanged,
            ),
          ],
        );
      },
    );
  }
}
