import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class FeedbackRepository {
  Stream<Result<List<FeedbackEntry>>> watchAll();
  Future<Result<FeedbackEntry?>> getById(int id);
  Future<Result<int>> insertEntry(FeedbackEntriesCompanion entry);
  Future<Result<void>> updateStatus({
    required int id,
    required String status,
    String? errorMessage,
    DateTime? sentAt,
  });

  Future<Result<void>> deleteById(int id);
}
