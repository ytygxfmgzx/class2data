import 'dart:async';

import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/achievement_dao.dart';
import 'package:class2data/domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementDao _dao;

  AchievementRepositoryImpl(this._dao);

  @override
  Stream<Result<List<Achievement>>> watchByChildId(int childId) {
    return _dao
        .watchByChildId(childId)
        .map((list) => Ok<List<Achievement>>(list))
        .handleError(
          (e) => Err<List<Achievement>>(DatabaseError('监听成就列表失败: $e')),
        );
  }

  @override
  Stream<Result<List<Achievement>>> watchByCourseId(int kidCourseId) {
    return _dao
        .watchByCourseId(kidCourseId)
        .map((list) => Ok<List<Achievement>>(list))
        .handleError(
          (e) => Err<List<Achievement>>(DatabaseError('监听课程成就失败: $e')),
        );
  }

  @override
  Future<Result<Achievement?>> getById(int id) async {
    try {
      return Ok(await _dao.getById(id));
    } catch (e) {
      return Err(DatabaseError('查询成就失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertAchievement(AchievementsCompanion entry) async {
    try {
      return Ok(await _dao.insertAchievement(entry));
    } catch (e) {
      return Err(DatabaseError('添加成就失败: $e'));
    }
  }

  @override
  Future<Result<void>> updateAchievement(AchievementsCompanion entry) async {
    try {
      await _dao.updateAchievement(entry);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('更新成就失败: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAchievement(int id) async {
    try {
      await _dao.deleteAchievement(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('删除成就失败: $e'));
    }
  }
}
