import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/course_statistics_service.dart';
import 'package:class2data/features/class_records/providers/class_record_providers.dart';
import 'package:class2data/features/growth/providers/growth_providers.dart'
    hide paymentsByCourseProvider;
import 'package:class2data/features/packages/providers/package_providers.dart';
import 'package:class2data/features/payments/providers/payment_providers.dart';
import 'package:class2data/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 单课程统计数据
final singleCourseStatisticsProvider =
    FutureProvider.family<CourseStatistics, int>((ref, courseId) async {
      final service = CourseStatisticsService();

      final recordsResult = await ref.watch(
        classRecordsByCourseProvider(courseId).future,
      );
      final records = switch (recordsResult) {
        Ok(:final value) => value,
        Err() => <ClassRecord>[],
      };

      final transactionsResult = await ref.watch(
        creditTransactionByCourseProvider(courseId).future,
      );
      final transactions = switch (transactionsResult) {
        Ok(:final value) => value,
        Err() => <CreditTransaction>[],
      };

      final paymentsResult = await ref.watch(
        paymentsByCourseProvider(courseId).future,
      );
      final payments = switch (paymentsResult) {
        Ok(:final value) => value,
        Err() => <Payment>[],
      };

      final packagesResult = await ref.watch(
        packagesByCourseProvider(courseId).future,
      );
      final pkgs = switch (packagesResult) {
        Ok(:final value) => value,
        Err() => <Package>[],
      };

      return service.computeStatistics(
        records: records,
        transactions: transactions,
        payments: payments,
        packages: pkgs,
      );
    });

/// 监听某孩子下的所有未归档课程
final coursesByChildProvider =
    StreamNotifierProvider.family<
      CoursesByChildNotifier,
      Result<List<KidCourse>>,
      int
    >(CoursesByChildNotifier.new);

class CoursesByChildNotifier
    extends FamilyStreamNotifier<Result<List<KidCourse>>, int> {
  @override
  Stream<Result<List<KidCourse>>> build(int arg) {
    final repo = ref.watch(kidCourseRepositoryProvider);
    return repo.watchByChildId(arg);
  }
}

/// 监听所有未归档课程
final allActiveCoursesProvider =
    StreamNotifierProvider<AllActiveCoursesNotifier, Result<List<KidCourse>>>(
      AllActiveCoursesNotifier.new,
    );

class AllActiveCoursesNotifier extends StreamNotifier<Result<List<KidCourse>>> {
  @override
  Stream<Result<List<KidCourse>>> build() {
    final repo = ref.watch(kidCourseRepositoryProvider);
    return repo.watchAllActive();
  }
}

/// 根据 ID 获取单个课程
final courseByIdProvider = FutureProvider.family<KidCourse?, int>((
  ref,
  id,
) async {
  final repo = ref.watch(kidCourseRepositoryProvider);
  final result = await repo.getById(id);
  return switch (result) {
    Ok(:final value) => value,
    Err() => null,
  };
});
