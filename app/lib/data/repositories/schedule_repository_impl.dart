import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/schedule_dao.dart';
import 'package:class2data/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDao _dao;

  ScheduleRepositoryImpl(this._dao);

  @override
  Stream<Result<List<CourseSchedule>>> watchActiveByCourseId(int courseId) {
    return _dao
        .watchActiveByCourseId(courseId)
        .map((list) => Ok<List<CourseSchedule>>(list))
        .handleError(
          (e) => Err<List<CourseSchedule>>(DatabaseError('监听计划列表失败: $e')),
        );
  }

  @override
  Stream<Result<List<CourseSchedule>>> watchAllByCourseId(int courseId) {
    return _dao
        .watchAllByCourseId(courseId)
        .map((list) => Ok<List<CourseSchedule>>(list))
        .handleError(
          (e) => Err<List<CourseSchedule>>(DatabaseError('监听计划列表失败: $e')),
        );
  }

  @override
  Future<Result<CourseSchedule?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询计划失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertSchedule(CourseSchedulesCompanion entry) async {
    try {
      return Ok(await _dao.insertSchedule(entry));
    } catch (e) {
      return Err(DatabaseError('添加计划失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateSchedule(CourseSchedulesCompanion entry) async {
    try {
      await _dao.updateSchedule(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新计划失败: $e'));
    }
  }

  @override
  Future<Result<void>> setPaused(int id, bool paused) async {
    try {
      await _dao.setPaused(id, paused);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('暂停/恢复计划失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteSchedule(int id) async {
    try {
      await _dao.deleteSchedule(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除计划失败: $e'));
    }
  }
}
