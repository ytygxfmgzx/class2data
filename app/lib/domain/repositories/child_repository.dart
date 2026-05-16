import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class ChildRepository {
  Future<Result<List<ChildrenData>>> getAllActive();
  Stream<Result<List<ChildrenData>>> watchAllActive();
  Future<Result<ChildrenData?>> getById(int id);
  Future<Result<int>> insertChild(ChildrenCompanion entry);
  Future<Result<void>> updateChild(ChildrenCompanion entry);
  Future<Result<void>> deleteChild(int id);
}
