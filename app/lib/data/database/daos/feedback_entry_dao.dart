import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'feedback_entry_dao.g.dart';

@DriftAccessor(tables: [FeedbackEntries])
class FeedbackEntryDao extends DatabaseAccessor<AppDatabase>
    with _$FeedbackEntryDaoMixin {
  FeedbackEntryDao(super.db);

  Stream<List<FeedbackEntry>> watchAll() {
    return (select(
      feedbackEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<FeedbackEntry?> getById(int id) {
    return (select(
      feedbackEntries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertEntry(FeedbackEntriesCompanion entry) {
    return into(feedbackEntries).insert(entry);
  }

  Future<void> updateStatus({
    required int id,
    required String status,
    String? errorMessage,
    DateTime? sentAt,
  }) {
    return (update(feedbackEntries)..where((t) => t.id.equals(id))).write(
      FeedbackEntriesCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        sentAt: Value(sentAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteById(int id) {
    return (delete(feedbackEntries)..where((t) => t.id.equals(id))).go();
  }
}
