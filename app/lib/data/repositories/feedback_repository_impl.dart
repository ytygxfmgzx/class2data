import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/feedback_entry_dao.dart';
import 'package:class2data/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackEntryDao _dao;

  FeedbackRepositoryImpl(this._dao);

  @override
  Stream<Result<List<FeedbackEntry>>> watchAll() {
    return _dao
        .watchAll()
        .map((list) => Ok<List<FeedbackEntry>>(list))
        .handleError(
          (e) => Err<List<FeedbackEntry>>(DatabaseError('监听反馈记录失败: $e')),
        );
  }

  @override
  Future<Result<FeedbackEntry?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询反馈记录失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertEntry(FeedbackEntriesCompanion entry) async {
    try {
      return Ok(await _dao.insertEntry(entry));
    } catch (e) {
      return Err(DatabaseError('保存反馈记录失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateStatus({
    required int id,
    required String status,
    String? errorMessage,
    DateTime? sentAt,
  }) async {
    try {
      await _dao.updateStatus(
        id: id,
        status: status,
        errorMessage: errorMessage,
        sentAt: sentAt,
      );
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新反馈状态失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteById(int id) async {
    try {
      await _dao.deleteById(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除反馈记录失败: $e'));
    }
  }
}
