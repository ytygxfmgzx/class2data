import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'tag_dao.g.dart';

/// 标签字典 DAO
@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  /// 按分类查询可见标签
  Future<List<Tag>> getByCategory(String category) {
    return (select(tags)
          ..where((t) => t.category.equals(category))
          ..where((t) => t.isHidden.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// 按分类和 code 查询单个标签
  Future<Tag?> getByCode(String category, String code) {
    return (select(tags)
          ..where((t) => t.category.equals(category))
          ..where((t) => t.code.equals(code)))
        .getSingleOrNull();
  }

  /// 新增用户自定义标签
  Future<int> insertCustomTag(TagsCompanion tag) {
    return into(tags).insert(tag);
  }

  /// 隐藏标签（不删除，保留历史引用）
  Future<void> hideTag(int id) {
    return (update(tags)..where((t) => t.id.equals(id))).write(
      const TagsCompanion(isHidden: Value(true)),
    );
  }
}
