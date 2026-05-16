import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/avatar_file_service.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ChildFormPage extends ConsumerStatefulWidget {
  final int? childId;

  const ChildFormPage({super.key, this.childId});

  @override
  ConsumerState<ChildFormPage> createState() => _ChildFormPageState();
}

class _ChildFormPageState extends ConsumerState<ChildFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  String? _avatarPath;
  String? _pendingImagePath;
  bool _avatarDeleted = false;

  bool get _isEditing => widget.childId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadChild();
    }
  }

  Future<void> _loadChild() async {
    final repo = ref.read(childRepositoryProvider);
    final result = await repo.getById(widget.childId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _nameController.text = value.name;
            _notesController.text = value.notes ?? '';
            _avatarPath = value.avatarPath;
          });
        }
      case Err():
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (xFile != null) {
      setState(() {
        _pendingImagePath = xFile.path;
        _avatarDeleted = false;
      });
    }
  }

  void _removeAvatar() {
    setState(() {
      _pendingImagePath = null;
      _avatarDeleted = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(childRepositoryProvider);
    final now = DateTime.now();

    try {
      if (_isEditing) {
        String? newAvatarPath = _avatarPath;

        if (_avatarDeleted) {
          await AvatarFileService.instance.deleteAvatar(_avatarPath);
          newAvatarPath = null;
        }

        if (_pendingImagePath != null) {
          await AvatarFileService.instance.deleteAvatar(_avatarPath);
          newAvatarPath = await AvatarFileService.instance.saveAvatar(
            widget.childId!,
            _pendingImagePath!,
          );
        }

        await repo.updateChild(
          ChildrenCompanion(
            id: Value(widget.childId!),
            name: Value(_nameController.text.trim()),
            avatarPath: Value(newAvatarPath),
            notes: Value(
              _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
            updatedAt: Value(now),
          ),
        );
      } else {
        final result = await repo.insertChild(
          ChildrenCompanion.insert(
            name: _nameController.text.trim(),
            notes: Value(
              _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
            createdAt: now,
            updatedAt: now,
          ),
        );

        final id = switch (result) {
          Ok(:final value) => value,
          Err(:final error) => throw error,
        };

        if (_pendingImagePath != null) {
          final avatarPath = await AvatarFileService.instance.saveAvatar(
            id,
            _pendingImagePath!,
          );
          await repo.updateChild(
            ChildrenCompanion(
              id: Value(id),
              avatarPath: Value(avatarPath),
              updatedAt: Value(now),
            ),
          );
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
        context.pop();
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑孩子' : '录入孩子'),
        actions: [
          if (_isEditing)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: _isLoading ? null : _delete,
              child: const Text('删除'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    _buildAvatarPreview(theme),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    if (_hasAvatar())
                      Positioned(
                        right: -4,
                        top: -4,
                        child: GestureDetector(
                          onTap: _removeAvatar,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: theme.colorScheme.onError,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _FormField(
              label: '姓名',
              child: TextFormField(
                controller: _nameController,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '请输入姓名' : null,
              ),
            ),
            const SizedBox(height: 16),
            _FormField(
              label: '备注',
              child: TextFormField(controller: _notesController, maxLines: 3),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasAvatar() {
    return _pendingImagePath != null ||
        (_avatarPath != null && !_avatarDeleted);
  }

  Widget _buildAvatarPreview(ThemeData theme) {
    if (_pendingImagePath != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(_pendingImagePath!)),
      );
    }
    if (_avatarPath != null && !_avatarDeleted) {
      return ChildAvatar(name: '', avatarPath: _avatarPath, radius: 40);
    }
    return CircleAvatar(
      radius: 40,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Text(
        _nameController.text.isNotEmpty ? _nameController.text[0] : '?',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 ${_nameController.text} 吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(childRepositoryProvider);
      final result = await repo.deleteChild(widget.childId!);
      if (result case Ok()) {
        ref.read(homeDataVersionProvider.notifier).state++;
        if (mounted) context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('删除孩子失败')));
      }
    }
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
