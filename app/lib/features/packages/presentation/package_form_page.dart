import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PackageFormPage extends ConsumerStatefulWidget {
  final int courseId;
  final int? packageId;

  const PackageFormPage({super.key, required this.courseId, this.packageId});

  @override
  ConsumerState<PackageFormPage> createState() => _PackageFormPageState();
}

class _PackageFormPageState extends ConsumerState<PackageFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _totalCreditsController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _packageType = 'lesson_pack';
  DateTime _purchaseDate = DateTime.now();
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isLoading = false;
  int? _oldTotalCredits;
  final List<String> _pendingPhotos = [];
  final List<String> _existingPhotos = [];
  final List<int> _existingPhotoIds = [];

  bool get _isEditing => widget.packageId != null;

  static const _packageTypes = [
    ('lesson_pack', '课时包'),
    ('trial_pack', '体验包'),
    ('gift_pack', '赠课包'),
    ('period_pack', '周期卡'),
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadPackage();
  }

  Future<void> _loadPackage() async {
    final repo = ref.read(packageRepositoryProvider);
    final result = await repo.getById(widget.packageId!);
    switch (result) {
      case Ok(:final value):
        if (value != null && mounted) {
          setState(() {
            _packageType = value.type;
            _purchaseDate = value.purchaseDate;
            _validFrom = value.validFrom;
            _validUntil = value.validUntil;
            _notesController.text = value.notes ?? '';
            _oldTotalCredits = value.totalCredits;
            if (value.totalCredits != null) {
              _totalCreditsController.text = CreditBalanceService()
                  .formatCredits(value.totalCredits!);
            }
            if (value.amountCents != null) {
              _amountController.text = (value.amountCents! / 100)
                  .toStringAsFixed(2);
            }
          });
        }
      case Err():
        break;
    }
    await _loadExistingPhotos();
  }

  Future<void> _loadExistingPhotos() async {
    if (widget.packageId == null) return;
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);
    final result = await attachRepo.getByOwnerIds('package', [
      widget.packageId!,
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
      });
    }
  }

  @override
  void dispose() {
    _totalCreditsController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final repo = ref.read(packageRepositoryProvider);

    int? totalCredits;
    if (_packageType != 'period_pack' &&
        _totalCreditsController.text.trim().isNotEmpty) {
      totalCredits = (double.parse(_totalCreditsController.text.trim()) * 100)
          .round();
    }

    int? amountCents;
    if (_amountController.text.trim().isNotEmpty) {
      amountCents = (double.parse(_amountController.text.trim()) * 100).round();
    }

    if (_isEditing) {
      final entry = PackagesCompanion(
        id: Value(widget.packageId!),
        kidCourseId: Value(widget.courseId),
        type: Value(_packageType),
        totalCredits: Value(totalCredits),
        amountCents: Value(amountCents),
        purchaseDate: Value(_purchaseDate),
        validFrom: Value(_validFrom),
        validUntil: Value(_validUntil),
        notes: Value(
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
        updatedAt: Value(now),
      );
      await repo.updatePackage(entry);

      // 课时数变化时创建 adjust 流水
      final oldCredits = _oldTotalCredits ?? 0;
      final newCredits = totalCredits ?? 0;
      final delta = newCredits - oldCredits;
      if (delta != 0) {
        final creditRepo = ref.read(creditTransactionRepositoryProvider);
        await creditRepo.insertTransaction(
          CreditTransactionsCompanion(
            kidCourseId: Value(widget.courseId),
            packageId: Value(widget.packageId!),
            type: const Value('adjust'),
            creditUnitsDelta: Value(delta),
            reason: const Value('修改课包课时'),
            transactionDate: Value(now),
            createdAt: Value(now),
          ),
        );
      }

      if (_pendingPhotos.isNotEmpty) {
        await _saveAttachments(widget.packageId!);
      }
    } else {
      final package = PackagesCompanion(
        kidCourseId: Value(widget.courseId),
        type: Value(_packageType),
        totalCredits: Value(totalCredits),
        amountCents: Value(amountCents),
        purchaseDate: Value(_purchaseDate),
        validFrom: Value(_validFrom),
        validUntil: Value(_validUntil),
        notes: Value(
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      CreditTransactionsCompanion? creditTx;
      if (totalCredits != null && totalCredits > 0) {
        creditTx = CreditTransactionsCompanion(
          kidCourseId: Value(widget.courseId),
          type: const Value('purchase'),
          creditUnitsDelta: Value(totalCredits),
          transactionDate: Value(_purchaseDate),
          createdAt: Value(now),
        );
      }

      final result = await repo.createPurchaseTransaction(
        package: package,
        creditTx: creditTx,
      );
      final pkgId = switch (result) {
        Ok(:final value) => value,
        Err() => null,
      };
      if (_pendingPhotos.isNotEmpty && pkgId != null) {
        await _saveAttachments(pkgId);
      }
    }

    if (mounted) {
      ref.read(homeDataVersionProvider.notifier).state++;
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  Future<void> _deletePackage() async {
    if (!_isEditing) return;

    final creditRepo = ref.read(creditTransactionRepositoryProvider);
    final txResult = await creditRepo.getByPackageId(widget.packageId!);
    final transactions = switch (txResult) {
      Ok(:final value) => value,
      Err() => <CreditTransaction>[],
    };
    final hasConsumed = transactions.any((t) => t.creditUnitsDelta < 0);

    if (!mounted) return;

    if (hasConsumed) {
      _showVoidDialog();
    } else {
      _showDirectDeleteDialog();
    }
  }

  void _showDirectDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除课包'),
        content: const Text('确定要删除这个课包吗？删除后无法恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              setState(() => _isLoading = true);
              await AttachmentFileService().deleteOwnerDirectory(
                'package',
                widget.packageId!,
              );
              final repo = ref.read(packageRepositoryProvider);
              await repo.deletePackage(widget.packageId!);
              if (mounted) {
                ref.read(homeDataVersionProvider.notifier).state++;
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) context.pop();
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showVoidDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除课包'),
        content: const Text(
          '该课包已有上课消耗记录，删除后剩余课时将被清零，已上课的记录和消耗仍会保留。\n\n此操作不可恢复。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              setState(() => _isLoading = true);
              await AttachmentFileService().deleteOwnerDirectory(
                'package',
                widget.packageId!,
              );
              final repo = ref.read(packageRepositoryProvider);
              final creditRepo = ref.read(creditTransactionRepositoryProvider);
              final balanceService = CreditBalanceService();
              final now = DateTime.now();

              final txResult = await creditRepo.getByPackageId(
                widget.packageId!,
              );
              final balance = switch (txResult) {
                Ok(:final value) => balanceService.packageBalance(value),
                Err() => 0,
              };

              if (balance != 0) {
                await repo.voidPackageTransaction(
                  packageId: widget.packageId!,
                  voidReason: '删除课包',
                  voidTx: CreditTransactionsCompanion(
                    kidCourseId: Value(widget.courseId),
                    packageId: Value(widget.packageId!),
                    type: const Value('void'),
                    creditUnitsDelta: Value(-balance),
                    reason: const Value('删除课包'),
                    transactionDate: Value(now),
                    createdAt: Value(now),
                  ),
                );
              } else {
                await repo.voidPackage(widget.packageId!, '删除课包');
              }

              if (mounted) {
                ref.read(homeDataVersionProvider.notifier).state++;
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) context.pop();
            },
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑课包' : '录入课包'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              tooltip: '删除',
              onPressed: _isLoading ? null : _deletePackage,
            ),
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
            _CourseChildHeader(courseId: widget.courseId),
            const SizedBox(height: 16),
            const _Label(label: '课包类型'),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: _packageTypes
                  .map((e) => ButtonSegment(value: e.$1, label: Text(e.$2)))
                  .toList(),
              selected: {_packageType},
              onSelectionChanged: (v) => setState(() => _packageType = v.first),
            ),
            const SizedBox(height: 16),

            if (_packageType != 'period_pack') ...[
              const _Label(label: '课时数'),
              const SizedBox(height: 4),
              TextFormField(
                controller: _totalCreditsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '如 10、1.5',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            const _Label(label: '金额（元）'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '如 2000，赠课包可留空',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const _Label(label: '购买日期'),
            const SizedBox(height: 4),
            _DateField(
              date: _purchaseDate,
              onPicked: (d) => setState(() => _purchaseDate = d),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label(label: '有效期自（可选）'),
                      const SizedBox(height: 4),
                      _DateField(
                        date: _validFrom,
                        onPicked: (d) => setState(() => _validFrom = d),
                        clearable: true,
                        onClear: () => setState(() => _validFrom = null),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Label(label: '有效期至（可选）'),
                      const SizedBox(height: 4),
                      _DateField(
                        date: _validUntil,
                        onPicked: (d) => setState(() => _validUntil = d),
                        clearable: true,
                        onClear: () => setState(() => _validUntil = null),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _Label(label: '备注'),
            const SizedBox(height: 4),
            TextFormField(controller: _notesController, maxLines: 2),
            const SizedBox(height: 16),

            // 照片上传
            const _Label(label: '照片（如收据）'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._existingPhotos.indexed.map((entry) {
                  final index = entry.$1;
                  final path = entry.$2;
                  return _PackagePhotoThumb(
                    path: path,
                    onRemove: () => _removeExistingPhoto(index),
                  );
                }),
                ..._pendingPhotos.indexed.map((entry) {
                  final index = entry.$1;
                  final path = entry.$2;
                  return _PackagePhotoThumb(
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
    if (source == ImageSource.camera) {
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
    } else {
      final xFiles = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFiles.isEmpty) return;
      setState(() {
        _pendingPhotos.addAll(xFiles.map((f) => f.path));
      });
    }
  }

  Future<void> _saveAttachments(int packageId) async {
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);

    for (final photoPath in _pendingPhotos) {
      try {
        // 先读取源文件信息（复制后源文件会被删除）
        final file = File(photoPath);
        final fileName = photoPath.split('/').last.split('\\').last;
        final fileSize = await file.length();

        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: photoPath,
          ownerType: 'package',
          ownerId: packageId,
        );

        await attachRepo.insertAttachment(
          AttachmentsCompanion(
            ownerType: const Value('package'),
            ownerId: Value(packageId),
            fileType: const Value('photo'),
            originalFileName: Value(fileName),
            relativePath: Value(relativePath),
            fileSizeBytes: Value(fileSize),
            createdAt: Value(DateTime.now()),
          ),
        );
      } catch (_) {}
    }
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
  final DateTime? date;
  final ValueChanged<DateTime> onPicked;
  final bool clearable;
  final VoidCallback? onClear;

  const _DateField({
    required this.date,
    required this.onPicked,
    this.clearable = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final text = date != null
        ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
        : '选择日期';

    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
          locale: const Locale('zh', 'CN'),
        );
        if (d != null) onPicked(d);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          suffixIcon: clearable && date != null && onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: date != null ? null : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

class _PackagePhotoThumb extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _PackagePhotoThumb({required this.path, required this.onRemove});

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

class _CourseChildHeader extends ConsumerWidget {
  final int courseId;

  const _CourseChildHeader({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final courseAsync = ref.watch(courseByIdProvider(courseId));
    final course = courseAsync.whenOrNull(data: (c) => c);
    if (course == null) return const SizedBox.shrink();

    final childrenAsync = ref.watch(activeChildrenProvider);
    final child = childrenAsync.whenOrNull(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.where((c) => c.id == course.childId).firstOrNull,
        Err() => null,
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (child != null) ...[
            ChildAvatar(
              name: child.name,
              avatarPath: child.avatarPath,
              radius: 16,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (child != null)
                  Text(
                    child.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 录入课时包浮层
class PackageFormBottomSheet extends ConsumerStatefulWidget {
  final int courseId;

  const PackageFormBottomSheet({super.key, required this.courseId});

  @override
  ConsumerState<PackageFormBottomSheet> createState() =>
      _PackageFormBottomSheetState();
}

class _PackageFormBottomSheetState
    extends ConsumerState<PackageFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _totalCreditsController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _packageType = 'lesson_pack';
  DateTime _purchaseDate = DateTime.now();
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isLoading = false;
  final List<String> _pendingPhotos = [];

  static const _packageTypes = [
    ('lesson_pack', '课时包'),
    ('trial_pack', '体验包'),
    ('gift_pack', '赠课包'),
    ('period_pack', '周期卡'),
  ];

  @override
  void dispose() {
    _totalCreditsController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final repo = ref.read(packageRepositoryProvider);

    int? totalCredits;
    if (_packageType != 'period_pack' &&
        _totalCreditsController.text.trim().isNotEmpty) {
      totalCredits = (double.parse(_totalCreditsController.text.trim()) * 100)
          .round();
    }

    int? amountCents;
    if (_amountController.text.trim().isNotEmpty) {
      amountCents = (double.parse(_amountController.text.trim()) * 100).round();
    }

    final package = PackagesCompanion(
      kidCourseId: Value(widget.courseId),
      type: Value(_packageType),
      totalCredits: Value(totalCredits),
      amountCents: Value(amountCents),
      purchaseDate: Value(_purchaseDate),
      validFrom: Value(_validFrom),
      validUntil: Value(_validUntil),
      notes: Value(
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    CreditTransactionsCompanion? creditTx;
    if (totalCredits != null && totalCredits > 0) {
      creditTx = CreditTransactionsCompanion(
        kidCourseId: Value(widget.courseId),
        type: const Value('purchase'),
        creditUnitsDelta: Value(totalCredits),
        transactionDate: Value(_purchaseDate),
        createdAt: Value(now),
      );
    }

    final result = await repo.createPurchaseTransaction(
      package: package,
      creditTx: creditTx,
    );
    final pkgId = switch (result) {
      Ok(:final value) => value,
      Err() => null,
    };

    if (_pendingPhotos.isNotEmpty && pkgId != null) {
      await _saveAttachments(pkgId);
    }

    if (mounted) {
      ref.read(homeDataVersionProvider.notifier).state++;
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
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
    if (source == ImageSource.camera) {
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
    } else {
      final xFiles = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFiles.isEmpty) return;
      setState(() {
        _pendingPhotos.addAll(xFiles.map((f) => f.path));
      });
    }
  }

  Future<void> _saveAttachments(int packageId) async {
    final fileService = ref.read(attachmentFileServiceProvider);
    final attachRepo = ref.read(attachmentRepositoryProvider);

    for (final photoPath in _pendingPhotos) {
      try {
        // 先读取源文件信息（复制后源文件会被删除）
        final file = File(photoPath);
        final fileName = photoPath.split('/').last.split('\\').last;
        final fileSize = await file.length();

        final relativePath = await fileService.copyToPrivateDirectory(
          sourcePath: photoPath,
          ownerType: 'package',
          ownerId: packageId,
        );

        await attachRepo.insertAttachment(
          AttachmentsCompanion(
            ownerType: const Value('package'),
            ownerId: Value(packageId),
            fileType: const Value('photo'),
            originalFileName: Value(fileName),
            relativePath: Value(relativePath),
            fileSizeBytes: Value(fileSize),
            createdAt: Value(DateTime.now()),
          ),
        );
      } catch (_) {}
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
                    '录入课时包',
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
                  _CourseChildHeader(courseId: widget.courseId),
                  const SizedBox(height: 16),
                  const _Label(label: '课包类型'),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: _packageTypes
                        .map(
                          (e) => ButtonSegment(value: e.$1, label: Text(e.$2)),
                        )
                        .toList(),
                    selected: {_packageType},
                    onSelectionChanged: (v) =>
                        setState(() => _packageType = v.first),
                  ),
                  const SizedBox(height: 16),
                  if (_packageType != 'period_pack') ...[
                    const _Label(label: '课时数'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _totalCreditsController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '如 10、1.5',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const _Label(label: '金额（元）'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '如 2000，赠课包可留空',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Label(label: '购买日期'),
                  const SizedBox(height: 4),
                  _DateField(
                    date: _purchaseDate,
                    onPicked: (d) => setState(() => _purchaseDate = d),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label(label: '有效期自（可选）'),
                            const SizedBox(height: 4),
                            _DateField(
                              date: _validFrom,
                              onPicked: (d) => setState(() => _validFrom = d),
                              clearable: true,
                              onClear: () => setState(() => _validFrom = null),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Label(label: '有效期至（可选）'),
                            const SizedBox(height: 4),
                            _DateField(
                              date: _validUntil,
                              onPicked: (d) => setState(() => _validUntil = d),
                              clearable: true,
                              onClear: () => setState(() => _validUntil = null),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _Label(label: '备注'),
                  const SizedBox(height: 4),
                  TextFormField(controller: _notesController, maxLines: 2),
                  const SizedBox(height: 16),
                  const _Label(label: '照片（如收据）'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._pendingPhotos.indexed.map((entry) {
                        final index = entry.$1;
                        final path = entry.$2;
                        return _PackagePhotoThumb(
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
          ),
        ],
      ),
    );
  }
}
