import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/feedback/services/feedback_service.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackService(repository);
});

final feedbackEntriesProvider =
    StreamNotifierProvider<
      FeedbackEntriesNotifier,
      Result<List<FeedbackEntry>>
    >(FeedbackEntriesNotifier.new);

class FeedbackEntriesNotifier
    extends StreamNotifier<Result<List<FeedbackEntry>>> {
  @override
  Stream<Result<List<FeedbackEntry>>> build() {
    final repository = ref.watch(feedbackRepositoryProvider);
    return repository.watchAll();
  }
}
