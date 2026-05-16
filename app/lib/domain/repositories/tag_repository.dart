import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';

/// 标签仓储接口
abstract class TagRepository {
  Future<Result<List<Tag>>> getTagsByCategory(String category);
  Future<Result<Tag?>> getTagByCode(String category, String code);
  Future<Result<int>> insertCustomTag(TagsCompanion tag);
  Future<Result<void>> hideTag(int id);
}
