import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/daos/achievement_dao.dart';
import '../../data/database/daos/attachment_dao.dart';
import '../../data/database/daos/child_dao.dart';
import '../../data/database/daos/class_record_dao.dart';
import '../../data/database/daos/contact_dao.dart';
import '../../data/database/daos/credit_transaction_dao.dart';
import '../../data/database/daos/feedback_entry_dao.dart';
import '../../data/database/daos/kid_course_dao.dart';
import '../../data/database/daos/package_dao.dart';
import '../../data/database/daos/payment_dao.dart';
import '../../data/database/daos/schedule_dao.dart';
import '../../data/database/daos/tag_dao.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../data/repositories/attachment_repository_impl.dart';
import '../../data/repositories/child_repository_impl.dart';
import '../../data/repositories/class_record_repository_impl.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../data/repositories/credit_transaction_repository_impl.dart';
import '../../data/repositories/feedback_repository_impl.dart';
import '../../data/repositories/kid_course_repository_impl.dart';
import '../../data/repositories/package_repository_impl.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/repositories/attachment_repository.dart';
import '../../domain/repositories/child_repository.dart';
import '../../domain/repositories/class_record_repository.dart';
import '../../domain/repositories/contact_repository.dart';
import '../../domain/repositories/credit_transaction_repository.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../../domain/repositories/kid_course_repository.dart';
import '../../domain/repositories/package_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/repositories/tag_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// === DAO ===

final tagDaoProvider = Provider<TagDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TagDao(db);
});

final childDaoProvider = Provider<ChildDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ChildDao(db);
});

final kidCourseDaoProvider = Provider<KidCourseDao>((ref) {
  final db = ref.watch(databaseProvider);
  return KidCourseDao(db);
});

final contactDaoProvider = Provider<ContactDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ContactDao(db);
});

final scheduleDaoProvider = Provider<ScheduleDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ScheduleDao(db);
});

final classRecordDaoProvider = Provider<ClassRecordDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ClassRecordDao(db);
});

final packageDaoProvider = Provider<PackageDao>((ref) {
  final db = ref.watch(databaseProvider);
  return PackageDao(db);
});

final paymentDaoProvider = Provider<PaymentDao>((ref) {
  final db = ref.watch(databaseProvider);
  return PaymentDao(db);
});

final creditTransactionDaoProvider = Provider<CreditTransactionDao>((ref) {
  final db = ref.watch(databaseProvider);
  return CreditTransactionDao(db);
});

final achievementDaoProvider = Provider<AchievementDao>((ref) {
  final db = ref.watch(databaseProvider);
  return AchievementDao(db);
});

final attachmentDaoProvider = Provider<AttachmentDao>((ref) {
  final db = ref.watch(databaseProvider);
  return AttachmentDao(db);
});

final feedbackEntryDaoProvider = Provider<FeedbackEntryDao>((ref) {
  final db = ref.watch(databaseProvider);
  return FeedbackEntryDao(db);
});

// === Repository ===

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final dao = ref.watch(tagDaoProvider);
  return TagRepositoryImpl(dao);
});

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final dao = ref.watch(childDaoProvider);
  return ChildRepositoryImpl(dao);
});

final kidCourseRepositoryProvider = Provider<KidCourseRepository>((ref) {
  final dao = ref.watch(kidCourseDaoProvider);
  return KidCourseRepositoryImpl(dao);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final dao = ref.watch(contactDaoProvider);
  return ContactRepositoryImpl(dao);
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final dao = ref.watch(scheduleDaoProvider);
  return ScheduleRepositoryImpl(dao);
});

final packageRepositoryProvider = Provider<PackageRepository>((ref) {
  final dao = ref.watch(packageDaoProvider);
  return PackageRepositoryImpl(dao);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dao = ref.watch(paymentDaoProvider);
  return PaymentRepositoryImpl(dao);
});

final creditTransactionRepositoryProvider =
    Provider<CreditTransactionRepository>((ref) {
      final dao = ref.watch(creditTransactionDaoProvider);
      return CreditTransactionRepositoryImpl(dao);
    });

final classRecordRepositoryProvider = Provider<ClassRecordRepository>((ref) {
  final dao = ref.watch(classRecordDaoProvider);
  return ClassRecordRepositoryImpl(dao);
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final dao = ref.watch(achievementDaoProvider);
  return AchievementRepositoryImpl(dao);
});

final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  final dao = ref.watch(attachmentDaoProvider);
  return AttachmentRepositoryImpl(dao);
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final dao = ref.watch(feedbackEntryDaoProvider);
  return FeedbackRepositoryImpl(dao);
});
