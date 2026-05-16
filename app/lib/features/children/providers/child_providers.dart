import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听所有未归档的孩子
final activeChildrenProvider =
    StreamNotifierProvider<ActiveChildrenNotifier, Result<List<ChildrenData>>>(
      ActiveChildrenNotifier.new,
    );

class ActiveChildrenNotifier
    extends StreamNotifier<Result<List<ChildrenData>>> {
  @override
  Stream<Result<List<ChildrenData>>> build() {
    final repo = ref.watch(childRepositoryProvider);
    return repo.watchAllActive();
  }
}

/// 根据 ID 获取单个孩子
final childByIdProvider = FutureProvider.family<ChildrenData?, int>((
  ref,
  id,
) async {
  final repo = ref.watch(childRepositoryProvider);
  final result = await repo.getById(id);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
});
