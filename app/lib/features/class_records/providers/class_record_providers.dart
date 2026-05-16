import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某课程下所有上课记录
final classRecordsByCourseProvider =
    StreamNotifierProvider.family<
      ClassRecordsByCourseNotifier,
      Result<List<ClassRecord>>,
      int
    >(ClassRecordsByCourseNotifier.new);

class ClassRecordsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<ClassRecord>>, int> {
  @override
  Stream<Result<List<ClassRecord>>> build(int arg) {
    final repo = ref.watch(classRecordRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}

/// 根据 ID 获取单个上课记录
final classRecordByIdProvider = FutureProvider.family<ClassRecord?, int>((
  ref,
  id,
) async {
  final repo = ref.watch(classRecordRepositoryProvider);
  final result = await repo.getById(id);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
});

/// 统计某课程上课次数
final classRecordCountProvider = FutureProvider.family<int, int>((
  ref,
  courseId,
) async {
  final repo = ref.watch(classRecordRepositoryProvider);
  final result = await repo.countByCourseId(courseId);
  return switch (result) {
    Ok(:final value) => value,
    Err() => 0,
  };
});
