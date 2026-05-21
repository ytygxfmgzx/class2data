import 'dart:io';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/attachment_file_service.dart';
import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:class2data/features/attachments/providers/attachment_providers.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/class_records/providers/class_record_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:class2data/shared/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ClassRecordDetailPage extends ConsumerStatefulWidget {
  final int recordId;

  const ClassRecordDetailPage({super.key, required this.recordId});

  @override
  ConsumerState<ClassRecordDetailPage> createState() =>
      _ClassRecordDetailPageState();
}

class _ClassRecordDetailPageState extends ConsumerState<ClassRecordDetailPage> {
  bool _isDeleting = false;

  Future<void> _deleteRecord() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除记录'),
        content: const Text('删除后不可恢复，关联的课时消耗将回退。确定要删除这条上课记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);

    try {
      final recordId = widget.recordId;
      final recordRepo = ref.read(classRecordRepositoryProvider);
      final attachmentRepo = ref.read(attachmentRepositoryProvider);
      final fileService = AttachmentFileService();

      final attachmentsResult = await attachmentRepo.getByOwner(
        'class_record',
        recordId,
      );
      final attachments = switch (attachmentsResult) {
        Ok(:final value) => value,
        Err() => <Attachment>[],
      };

      await recordRepo.deleteTransactionsByRecordId(recordId);
      await attachmentRepo.deleteByOwner('class_record', recordId);

      for (final a in attachments) {
        await fileService.deleteFile(a.relativePath);
      }
      await fileService.deleteOwnerDirectory('class_record', recordId);

      await recordRepo.deleteRecord(recordId);

      // 递增首页数据版本号，触发所有首页 provider 重新加载
      if (mounted) {
        ref.read(homeDataVersionProvider.notifier).state++;
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('记录已删除')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recordAsync = ref.watch(classRecordByIdProvider(widget.recordId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('上课记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _isDeleting ? null : _deleteRecord,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _isDeleting
                ? null
                : () => context.push('/class-records/${widget.recordId}/edit'),
          ),
        ],
      ),
      body: _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : recordAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败: $e')),
              data: (record) {
                if (record == null) {
                  return const Center(child: Text('记录不存在'));
                }
                return _DetailContent(
                  record: record,
                  recordId: widget.recordId,
                );
              },
            ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final ClassRecord record;
  final int recordId;

  const _DetailContent({required this.record, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(record.status);
    final statusLabel = _statusLabel(record.status);
    final balanceService = CreditBalanceService();

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // 状态横幅
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: statusColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              // 顶部彩色条
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${record.classDate}  ${record.startTime}'
                          '${record.endTime != null ? '-${record.endTime}' : ''}',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 信息卡片
        _InfoCard(
          children: [
            // 孩子和课程（需要异步加载）
            _ChildCourseRows(kidCourseId: record.kidCourseId),
            _Divider(),
            _InfoRow(
              icon: Icons.timelapse_outlined,
              label: '课时',
              value: balanceService.formatCredits(record.creditUnitsCost),
            ),
            if (record.creditUnitsCost > 0) ...[
              const SizedBox(height: 10),
              _PackageInfoRow(packageId: record.packageId),
            ],
            if (record.durationMinutes != null) ...[
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.timer_outlined,
                label: '时长',
                value: '${record.durationMinutes} 分钟',
              ),
            ],
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              _Divider(),
              _InfoRow(
                icon: Icons.notes_outlined,
                label: '备注',
                value: record.notes!,
              ),
            ],
            _Divider(),
            _InfoRow(
              icon: Icons.access_time,
              label: '记录时间',
              value: DateFormat('yyyy-MM-dd HH:mm').format(record.createdAt),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 照片
        _PhotoSection(recordId: recordId),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _ChildCourseRows extends ConsumerWidget {
  final int kidCourseId;

  const _ChildCourseRows({required this.kidCourseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseByIdProvider(kidCourseId));

    return courseAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (course) {
        if (course == null) return const SizedBox.shrink();

        final childAsync = ref.watch(childByIdProvider(course.childId));

        return childAsync.when(
          loading: () => _InfoRow(
            icon: Icons.school_outlined,
            label: '课程',
            value: course.name,
          ),
          error: (_, _) => _InfoRow(
            icon: Icons.school_outlined,
            label: '课程',
            value: course.name,
          ),
          data: (child) => Column(
            children: [
              if (child != null)
                _InfoRow(
                  icon: Icons.child_care_outlined,
                  label: '孩子',
                  value: child.name,
                ),
              if (child != null) const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.school_outlined,
                label: '课程',
                value: course.name,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PackageInfoRow extends ConsumerWidget {
  final int? packageId;

  const _PackageInfoRow({required this.packageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (packageId == null) {
      return const _InfoRow(
        icon: Icons.inventory_2_outlined,
        label: '所属课包',
        value: '未关联课包',
      );
    }

    final packageAsync = ref.watch(packageByIdProvider(packageId!));

    return packageAsync.when(
      loading: () => const _InfoRow(
        icon: Icons.inventory_2_outlined,
        label: '所属课包',
        value: '加载中...',
      ),
      error: (_, _) => const _InfoRow(
        icon: Icons.inventory_2_outlined,
        label: '所属课包',
        value: '加载失败',
      ),
      data: (package) {
        if (package == null) {
          return const _InfoRow(
            icon: Icons.inventory_2_outlined,
            label: '所属课包',
            value: '课包不存在',
          );
        }

        return _InfoRow(
          icon: Icons.inventory_2_outlined,
          label: '所属课包',
          value: _formatPackage(package),
        );
      },
    );
  }

  String _formatPackage(Package package) {
    final balanceService = CreditBalanceService();
    final parts = <String>[
      balanceService.packageTypeLabel(package.type),
      '购买 ${balanceService.formatDate(package.purchaseDate)}',
    ];

    if (package.type == 'period_pack') {
      parts.add(
        balanceService.periodPackageValidityLabel(
          package.validFrom,
          package.validUntil,
        ),
      );
    } else if (package.totalCredits != null) {
      parts.add('${balanceService.formatCredits(package.totalCredits!)}课时');
    }

    return parts.join(' · ');
  }
}

class _PhotoSection extends ConsumerWidget {
  final int recordId;

  const _PhotoSection({required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachmentsAsync = ref.watch(
      attachmentsByOwnerProvider((
        ownerType: 'class_record',
        ownerId: recordId,
      )),
    );

    return attachmentsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '照片',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${value.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PhotoGrid(attachments: value),
                  ],
                ),
        Err() => const SizedBox.shrink(),
      },
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final List<Attachment> attachments;

  const _PhotoGrid({required this.attachments});

  @override
  Widget build(BuildContext context) {
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
              return _PhotoThumb(
                attachment: attachment,
                size: itemSize,
                onTap: () => _openViewer(context, index),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _openViewer(BuildContext context, int initialIndex) async {
    final paths = <String>[];
    for (final a in attachments) {
      final absPath = await AttachmentFileService().getAbsolutePath(
        a.relativePath,
      );
      paths.add(absPath);
    }
    if (context.mounted) {
      await PhotoViewerDialog.show(
        context,
        imagePaths: paths,
        initialIndex: initialIndex,
      );
    }
  }
}

class _PhotoThumb extends StatelessWidget {
  final Attachment attachment;
  final double size;
  final VoidCallback onTap;

  const _PhotoThumb({
    required this.attachment,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: FutureBuilder<String>(
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
          ),
        ),
      ),
    );
  }
}

String _statusLabel(String status) {
  return switch (status) {
    'attended' => '已上课',
    'leave' => '请假',
    'cancelled' => '取消',
    'absent' => '缺课',
    'makeup' => '补课',
    _ => status,
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'attended' => Colors.green,
    'leave' => Colors.orange,
    'cancelled' => Colors.grey,
    'absent' => Colors.red,
    'makeup' => Colors.blue,
    _ => Colors.grey,
  };
}
