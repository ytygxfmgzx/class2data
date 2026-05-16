import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/kid_course_dao.dart';
import 'package:class2data/domain/repositories/kid_course_repository.dart';

class KidCourseRepositoryImpl implements KidCourseRepository {
  final KidCourseDao _dao;

  KidCourseRepositoryImpl(this._dao);

  @override
  Stream<Result<List<KidCourse>>> watchByChildId(int childId) {
    return _dao
        .watchByChildId(childId)
        .map((list) => Ok<List<KidCourse>>(list))
        .handleError(
          (e) => Err<List<KidCourse>>(DatabaseError('监听课程列表失败: $e')),
        );
  }

  @override
  Stream<Result<List<KidCourse>>> watchAllActive() {
    return _dao
        .watchAllActive()
        .map((list) => Ok<List<KidCourse>>(list))
        .handleError(
          (e) => Err<List<KidCourse>>(DatabaseError('监听课程列表失败: $e')),
        );
  }

  @override
  Future<Result<KidCourse?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询课程失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertCourse(KidCoursesCompanion entry) async {
    try {
      return Ok(await _dao.insertCourse(entry));
    } catch (e) {
      return Err(DatabaseError('添加课程失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateCourse(KidCoursesCompanion entry) async {
    try {
      await _dao.updateCourse(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新课程失败: $e'));
    }
  }

  @override
  Future<Result<void>> archiveCourse(int id) async {
    try {
      await _dao.archiveCourse(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('归档课程失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteCourse(int id) async {
    try {
      await _dao.deleteCourse(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除课程失败: $e'));
    }
  }
}
