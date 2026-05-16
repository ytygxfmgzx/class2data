import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/tag_dao.dart';
import 'package:class2data/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagDao _dao;

  TagRepositoryImpl(this._dao);

  @override
  Future<Result<List<Tag>>> getTagsByCategory(String category) async {
    try {
      final tags = await _dao.getByCategory(category);
      return Ok(tags);
    } catch (e) {
      return Err(DatabaseError('查询标签失败: $e'));
    }
  }

  @override
  Future<Result<Tag?>> getTagByCode(String category, String code) async {
    try {
      final tag = await _dao.getByCode(category, code);
      return Ok(tag);
    } catch (e) {
      return Err(DatabaseError('查询标签失败: $e'));
    }
  }

  @override
  Future<Result<int>> insertCustomTag(TagsCompanion tag) async {
    try {
      final id = await _dao.insertCustomTag(tag);
      return Ok(id);
    } catch (e) {
      return Err(DatabaseError('新增标签失败: $e'));
    }
  }

  @override
  Future<Result<void>> hideTag(int id) async {
    try {
      await _dao.hideTag(id);
      return const Ok(null);
    } catch (e) {
      return Err(DatabaseError('隐藏标签失败: $e'));
    }
  }
}
