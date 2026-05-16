import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某课程下所有课包（含已作废）
final packagesByCourseProvider =
    StreamNotifierProvider.family<
      PackagesByCourseNotifier,
      Result<List<Package>>,
      int
    >(PackagesByCourseNotifier.new);

class PackagesByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Package>>, int> {
  @override
  Stream<Result<List<Package>>> build(int arg) {
    final repo = ref.watch(packageRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 监听某课程下可用课包（不含已作废）
final activePackagesByCourseProvider =
    StreamNotifierProvider.family<
      ActivePackagesByCourseNotifier,
      Result<List<Package>>,
      int
    >(ActivePackagesByCourseNotifier.new);

class ActivePackagesByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Package>>, int> {
  @override
  Stream<Result<List<Package>>> build(int arg) {
    final repo = ref.watch(packageRepositoryProvider);
    return repo.watchActiveByCourseId(arg);
  }
}

/// 根据 ID 获取单个课包
final packageByIdProvider = FutureProvider.family<Package?, int>((
  ref,
  id,
) async {
  final repo = ref.watch(packageRepositoryProvider);
  final result = await repo.getById(id);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
});
