import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

abstract class ContactRepository {
  Stream<Result<List<Contact>>> watchByCourseId(int courseId);
  Future<Result<Contact?>> getById(int id);
  Future<Result<int>> insertContact(ContactsCompanion entry);
  Future<Result<void>> updateContact(ContactsCompanion entry);
  Future<Result<void>> deleteContact(int id);
}
