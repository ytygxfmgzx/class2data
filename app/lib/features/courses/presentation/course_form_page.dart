import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CourseFormPage extends ConsumerStatefulWidget {
  final int? childId;
  final int? courseId;

  const CourseFormPage({super.key, this.childId, this.courseId});

  @override
  ConsumerState<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends ConsumerState<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _institutionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _defaultCreditsController = TextEditingController();
  final _defaultDurationController = TextEditingController();

  int? _selectedChildId;
  bool _isLoading = false;
  bool _didApplySingleChildDefault = false;

  bool get _isEditing => widget.courseId != null;

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.childId;
    if (_isEditing) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    final repo = ref.read(kidCourseRepositoryProvider);
    final result = await repo.getById(widget.courseId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _selectedChildId = value.childId;
            _nameController.text = value.name;
            _institutionController.text = value.institutionName ?? '';
            _locationController.text = value.location ?? '';
            _notesController.text = value.notes ?? '';
            if (value.defaultCreditUnitsCost != null) {
              _defaultCreditsController.text =
                  (value.defaultCreditUnitsCost! / 100).toString();
            }
            if (value.defaultDurationMinutes != null) {
              _defaultDurationController.text = value.defaultDurationMinutes
                  .toString();
            }
          });
        }
      case Err():
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _defaultCreditsController.dispose();
    _defaultDurationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedChildId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请选择孩子')));
      return;
    }

    setState(() => _isLoading = true);

    final repo = ref.read(kidCourseRepositoryProvider);
    final now = DateTime.now();

    final credits = _defaultCreditsController.text.trim();
    final duration = _defaultDurationController.text.trim();

    if (_isEditing) {
      await repo.updateCourse(
        KidCoursesCompanion(
          id: Value(widget.courseId!),
          childId: Value(_selectedChildId!),
          name: Value(_nameController.text.trim()),
          institutionName: Value(
            _institutionController.text.trim().isEmpty
                ? null
                : _institutionController.text.trim(),
          ),
          location: Value(
            _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
          ),
          defaultCreditUnitsCost: Value(
            credits.isEmpty ? null : (double.parse(credits) * 100).round(),
          ),
          defaultDurationMinutes: Value(
            duration.isEmpty ? null : int.parse(duration),
          ),
          notes: Value(
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          ),
          updatedAt: Value(now),
        ),
      );
    } else {
      final result = await repo.insertCourse(
        KidCoursesCompanion.insert(
          childId: _selectedChildId!,
          name: _nameController.text.trim(),
          institutionName: Value(
            _institutionController.text.trim().isEmpty
                ? null
                : _institutionController.text.trim(),
          ),
          location: Value(
            _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
          ),
          defaultCreditUnitsCost: Value(
            credits.isEmpty ? null : (double.parse(credits) * 100).round(),
          ),
          defaultDurationMinutes: Value(
            duration.isEmpty ? null : int.parse(duration),
          ),
          notes: Value(
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          ),
          createdAt: now,
          updatedAt: now,
        ),
      );
      final newId = switch (result) {
        Ok(:final value) => value,
        Err() => null,
      };
      if (mounted) {
        setState(() => _isLoading = false);
        if (newId != null) {
          context.pop(newId);
        } else {
          context.pop();
        }
      }
      return;
    }

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(activeChildrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑课程' : '录入课程'),
        actions: [
          if (_isEditing)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
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
            // 孩子选择
            const _FormLabel(label: '孩子'),
            const SizedBox(height: 4),
            childrenAsync.when(
              loading: () => const SizedBox(
                height: 48,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (e, _) => Text('加载失败: $e'),
              data: (result) => switch (result) {
                Ok(:final value) => _buildChildDropdown(value),
                Err(:final error) => Text(error.message),
              },
            ),
            const SizedBox(height: 16),
            const _FormLabel(label: '课程名称'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nameController,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? '请输入课程名称' : null,
            ),
            const SizedBox(height: 16),
            const _FormLabel(label: '机构名称'),
            const SizedBox(height: 4),
            TextFormField(controller: _institutionController),
            const SizedBox(height: 16),
            const _FormLabel(label: '地点'),
            const SizedBox(height: 4),
            TextFormField(controller: _locationController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormLabel(label: '默认课时'),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _defaultCreditsController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormLabel(label: '默认时长(分钟)'),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _defaultDurationController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _FormLabel(label: '备注'),
            const SizedBox(height: 4),
            TextFormField(controller: _notesController, maxLines: 3),
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

  Widget _buildChildDropdown(List<ChildrenData> children) {
    _applySingleChildDefault(children);
    final effectiveSelectedId =
        _selectedChildId ??
        (!_isEditing && children.length == 1 ? children.first.id : null);

    return _ChildDropdown(
      children: children,
      selectedId: effectiveSelectedId,
      onChanged: (id) => setState(() {
        _didApplySingleChildDefault = true;
        _selectedChildId = id;
      }),
    );
  }

  void _applySingleChildDefault(List<ChildrenData> children) {
    if (_isEditing ||
        _selectedChildId != null ||
        _didApplySingleChildDefault ||
        children.length != 1) {
      return;
    }

    _didApplySingleChildDefault = true;
    final childId = children.first.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedChildId != null) return;
      setState(() => _selectedChildId = childId);
    });
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除课程「${_nameController.text}」吗？删除后无法恢复。'),
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
      final repo = ref.read(kidCourseRepositoryProvider);
      final result = await repo.deleteCourse(widget.courseId!);
      if (result case Ok()) {
        ref.read(homeDataVersionProvider.notifier).state++;
        if (mounted) context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('删除课程失败')));
      }
    }
  }
}

class _ChildDropdown extends StatelessWidget {
  final List<ChildrenData> children;
  final int? selectedId;
  final ValueChanged<int?>? onChanged;

  const _ChildDropdown({
    required this.children,
    this.selectedId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: children
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;

  const _FormLabel({required this.label});

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
