import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 监听某课程下所有联系人
final contactsByCourseProvider =
    StreamNotifierProvider.family<
      ContactsByCourseNotifier,
      Result<List<Contact>>,
      int
    >(ContactsByCourseNotifier.new);

class ContactsByCourseNotifier
    extends FamilyStreamNotifier<Result<List<Contact>>, int> {
  @override
  Stream<Result<List<Contact>>> build(int arg) {
    final repo = ref.watch(contactRepositoryProvider);
    return repo.watchByCourseId(arg);
  }
}
