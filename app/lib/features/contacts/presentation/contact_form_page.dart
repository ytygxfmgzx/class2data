import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactFormPage extends ConsumerStatefulWidget {
  final int courseId;
  final int? contactId;

  const ContactFormPage({super.key, required this.courseId, this.contactId});

  @override
  ConsumerState<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends ConsumerState<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wechatController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedRole;

  bool _isLoading = false;
  bool get _isEditing => widget.contactId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadContact();
  }

  Future<void> _loadContact() async {
    final repo = ref.read(contactRepositoryProvider);
    final result = await repo.getById(widget.contactId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _nameController.text = value.name;
            _phoneController.text = value.phone ?? '';
            _wechatController.text = value.wechat ?? '';
            _notesController.text = value.notes ?? '';
            _selectedRole = value.role;
          });
        }
      case Err():
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _wechatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(contactRepositoryProvider);
    final now = DateTime.now();
    final name = _nameController.text.trim();

    if (_isEditing) {
      await repo.updateContact(
        ContactsCompanion(
          id: Value(widget.contactId!),
          name: Value(name),
          role: Value(_selectedRole),
          roleNameSnapshot: Value(_selectedRole),
          phone: Value(
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          ),
          wechat: Value(
            _wechatController.text.trim().isEmpty
                ? null
                : _wechatController.text.trim(),
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
      await repo.insertContact(
        ContactsCompanion.insert(
          kidCourseId: widget.courseId,
          name: name,
          role: Value(_selectedRole),
          roleNameSnapshot: Value(_selectedRole),
          phone: Value(
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          ),
          wechat: Value(
            _wechatController.text.trim().isEmpty
                ? null
                : _wechatController.text.trim(),
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
    }

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑联系人' : '添加联系人'),
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
            const _Label(label: '姓名'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nameController,
              validator: (v) => v == null || v.trim().isEmpty ? '请输入姓名' : null,
            ),
            const SizedBox(height: 16),
            const _Label(label: '角色'),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'teacher', child: Text('老师')),
                DropdownMenuItem(value: 'coach', child: Text('教练')),
                DropdownMenuItem(value: 'advisor', child: Text('顾问')),
              ],
              onChanged: (v) => setState(() => _selectedRole = v),
            ),
            const SizedBox(height: 16),
            const _Label(label: '电话'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const _Label(label: '微信'),
            const SizedBox(height: 4),
            TextFormField(controller: _wechatController),
            const SizedBox(height: 16),
            const _Label(label: '备注'),
            const SizedBox(height: 4),
            TextFormField(controller: _notesController, maxLines: 3),
            const SizedBox(height: 24),
            if (_isEditing)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: _isLoading ? null : _delete,
                child: const Text('删除'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 ${_nameController.text} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(contactRepositoryProvider);
      await repo.deleteContact(widget.contactId!);
      if (mounted) context.pop();
    }
  }
}

class ContactFormBottomSheet extends ConsumerStatefulWidget {
  final int courseId;

  const ContactFormBottomSheet({super.key, required this.courseId});

  @override
  ConsumerState<ContactFormBottomSheet> createState() =>
      _ContactFormBottomSheetState();
}

class _ContactFormBottomSheetState
    extends ConsumerState<ContactFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _wechatController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedRole = 'teacher';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _wechatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(contactRepositoryProvider);
    final now = DateTime.now();
    final name = _nameController.text.trim();

    await repo.insertContact(
      ContactsCompanion.insert(
        kidCourseId: widget.courseId,
        name: name,
        role: Value(_selectedRole),
        roleNameSnapshot: Value(_selectedRole),
        phone: Value(
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
        wechat: Value(
          _wechatController.text.trim().isEmpty
              ? null
              : _wechatController.text.trim(),
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

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '添加联系人',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _isLoading ? null : _save,
                  child: const Text('保存'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _Label(label: '姓名'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? '请输入姓名' : null,
                  ),
                  const SizedBox(height: 16),
                  const _Label(label: '角色'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'teacher', child: Text('老师')),
                      DropdownMenuItem(value: 'coach', child: Text('教练')),
                      DropdownMenuItem(value: 'advisor', child: Text('顾问')),
                    ],
                    onChanged: (v) => setState(() => _selectedRole = v),
                  ),
                  const SizedBox(height: 16),
                  const _Label(label: '电话'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  const _Label(label: '微信'),
                  const SizedBox(height: 4),
                  TextFormField(controller: _wechatController),
                  const SizedBox(height: 16),
                  const _Label(label: '备注'),
                  const SizedBox(height: 4),
                  TextFormField(controller: _notesController, maxLines: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
