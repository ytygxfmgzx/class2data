import 'package:drift/drift.dart';

import '../app_database.dart';

/// 数据导出 DAO。
///
/// 查询各表全部数据，返回原始 Map 列表，用于 JSON/CSV 序列化。
/// 使用原始 SQL 查询，不依赖 Drift 代码生成的类型化访问器。
class ExportDao extends DatabaseAccessor<AppDatabase> {
  ExportDao(super.db);

  static const _tables = [
    'children',
    'kid_courses',
    'course_schedules',
    'packages',
    'class_records',
    'credit_transactions',
    'payments',
    'achievements',
    'achievement_type_links',
    'attachments',
    'contacts',
    'tags',
    'feedback_entries',
  ];

  /// 查询指定表全部数据。
  Future<List<Map<String, dynamic>>> exportTable(String tableName) async {
    if (!_tables.contains(tableName)) {
      throw ArgumentError('不支持的表名: $tableName');
    }
    final rows = await customSelect('SELECT * FROM $tableName').get();
    return rows.map((row) => row.data).toList();
  }

  /// 查询所有表数据，返回表名到行列表的映射。
  Future<Map<String, List<Map<String, dynamic>>>> exportAll() async {
    final result = <String, List<Map<String, dynamic>>>{};
    for (final tableName in _tables) {
      result[tableName] = await exportTable(tableName);
    }
    return result;
  }
}
