import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreditAdjustmentFormPage extends ConsumerStatefulWidget {
  final int courseId;

  const CreditAdjustmentFormPage({super.key, required this.courseId});

  @override
  ConsumerState<CreditAdjustmentFormPage> createState() =>
      _CreditAdjustmentFormPageState();
}

class _CreditAdjustmentFormPageState
    extends ConsumerState<CreditAdjustmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _creditsController = TextEditingController();
  final _reasonController = TextEditingController();

  String _adjustType = 'adjust';
  int? _selectedPackageId;
  bool _isLoading = false;

  @override
  void dispose() {
    _creditsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final repo = ref.read(creditTransactionRepositoryProvider);
    final now = DateTime.now();

    final credits = double.parse(_creditsController.text.trim());
    int delta = (credits * 100).round();
    if (_adjustType == 'refund') delta = -delta;

    await repo.insertTransaction(
      CreditTransactionsCompanion(
        kidCourseId: Value(widget.courseId),
        packageId: Value(_selectedPackageId),
        type: Value(_adjustType),
        creditUnitsDelta: Value(delta),
        reason: Value(_reasonController.text.trim()),
        transactionDate: Value(now),
        createdAt: Value(now),
      ),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(
      activePackagesByCourseProvider(widget.courseId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('手动调整'),
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
            const _Label(label: '调整类型'),
            const SizedBox(height: 4),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'adjust', label: Text('调整')),
                ButtonSegment(value: 'refund', label: Text('退款')),
              ],
              selected: {_adjustType},
              onSelectionChanged: (v) => setState(() => _adjustType = v.first),
            ),
            const SizedBox(height: 16),

            const _Label(label: '课时数'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _creditsController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '必填';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return '请输入正数';
                return null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _adjustType == 'adjust' ? '增加的课时' : '退回的课时',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const _Label(label: '关联课包（可选）'),
            const SizedBox(height: 4),
            packagesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, st) => const Text('加载课包失败'),
              data: (result) => switch (result) {
                Ok(:final value) => DropdownButtonFormField<int>(
                  initialValue: _selectedPackageId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '不选则记为课程级别调整',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: value
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(
                            '${p.type} · ${p.purchaseDate.month}/${p.purchaseDate.day}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPackageId = v),
                ),
                Err() => const Text('加载课包失败'),
              },
            ),
            const SizedBox(height: 16),

            const _Label(label: '备注'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _reasonController,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? '调整必须填写备注' : null,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '说明调整原因',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
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
