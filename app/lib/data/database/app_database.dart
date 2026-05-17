import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Children,
    KidCourses,
    CourseSchedules,
    Packages,
    ClassRecords,
    CreditTransactions,
    Payments,
    Achievements,
    AchievementTypeLinks,
    Attachments,
    Contacts,
    Tags,
    FeedbackEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertPresetTags();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await _safeAddColumn(m, courseSchedules, courseSchedules.slotsJson);
          await _safeAddColumn(m, courseSchedules, courseSchedules.location);
          await _ensurePresetTags();
        }
        if (from < 3) {
          await m.createTable(feedbackEntries);
        }
        if (from < 4) {
          await _safeAddColumn(m, payments, payments.achievementId);
          await m.createTable(achievementTypeLinks);
          await _ensurePresetTags();
        }
      },
    );
  }

  /// 执行 WAL checkpoint，确保持久化到主数据库文件。
  Future<void> checkpoint() async {
    await customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
  }

  /// 获取数据库文件路径。
  static Future<String> getDatabasePath() async {
    final dbFolder = await getDatabaseDir();
    return p.join(dbFolder.path, 'class2data.db');
  }

  /// 安全添加列，已存在时跳过（SQLite ALTER TABLE 不可回滚，防止部分迁移重跑报错）。
  Future<void> _safeAddColumn(
    Migrator m,
    TableInfo table,
    GeneratedColumn column,
  ) async {
    try {
      await m.addColumn(table, column);
    } catch (_) {
      // duplicate column name — 列已存在，跳过
    }
  }

  /// 补齐新增的预设标签（升级时使用，INSERT OR IGNORE 已存在的不会重复插入）。
  Future<void> _ensurePresetTags() async {
    final now = DateTime.now();
    for (final t in _presetTags) {
      await into(tags).insert(
        TagsCompanion.insert(
          category: t.category,
          code: t.code,
          displayName: t.displayName,
          isSystem: Value(t.isSystem),
          sortOrder: Value(t.sortOrder),
          createdAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> _insertPresetTags() async {
    final now = DateTime.now();
    await batch((b) {
      b.insertAll(
        tags,
        _presetTags.map(
          (t) => TagsCompanion.insert(
            category: t.category,
            code: t.code,
            displayName: t.displayName,
            isSystem: Value(t.isSystem),
            sortOrder: Value(t.sortOrder),
            createdAt: now,
          ),
        ),
      );
    });
  }
}

/// 获取应用数据根目录（Windows 用 AppData\Roaming，其他平台用 Documents）。
Future<Directory> getDatabaseDir() async {
  if (Platform.isWindows) {
    return getApplicationSupportDirectory();
  }
  return getApplicationDocumentsDirectory();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getDatabaseDir();
    final file = File(p.join(dbFolder.path, 'class2data.db'));
    return NativeDatabase.createInBackground(file);
  });
}

class _PresetTag {
  final String category;
  final String code;
  final String displayName;
  final bool isSystem;
  final int sortOrder;

  const _PresetTag({
    required this.category,
    required this.code,
    required this.displayName,
    this.isSystem = true,
    required this.sortOrder,
  });
}

const _presetTags = <_PresetTag>[
  // 课包类型
  _PresetTag(
    category: 'package_type',
    code: 'lesson_pack',
    displayName: '课时包',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'package_type',
    code: 'trial_pack',
    displayName: '体验包',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'package_type',
    code: 'gift_pack',
    displayName: '赠课包',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'package_type',
    code: 'period_pack',
    displayName: '周期卡',
    sortOrder: 4,
  ),
  // 计划类型
  _PresetTag(
    category: 'schedule_type',
    code: 'weekly_repeat',
    displayName: '周循环',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'schedule_type',
    code: 'monthly_repeat',
    displayName: '月循环',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'schedule_type',
    code: 'daily_repeat',
    displayName: '每天重复',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'schedule_type',
    code: 'single',
    displayName: '单次',
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'schedule_type',
    code: 'date_list',
    displayName: '指定日期',
    sortOrder: 5,
  ),
  // 课时流水类型
  _PresetTag(
    category: 'credit_tx_type',
    code: 'purchase',
    displayName: '购入',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'credit_tx_type',
    code: 'consume',
    displayName: '消耗',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'credit_tx_type',
    code: 'adjust',
    displayName: '调整',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'credit_tx_type',
    code: 'refund',
    displayName: '退款',
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'credit_tx_type',
    code: 'void',
    displayName: '作废',
    sortOrder: 5,
  ),
  _PresetTag(
    category: 'credit_tx_type',
    code: 'pending',
    displayName: '待确认',
    sortOrder: 6,
  ),
  // 上课记录状态
  _PresetTag(
    category: 'class_status',
    code: 'attended',
    displayName: '已上课',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'class_status',
    code: 'leave',
    displayName: '请假',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'class_status',
    code: 'cancelled',
    displayName: '取消',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'class_status',
    code: 'absent',
    displayName: '缺课',
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'class_status',
    code: 'makeup',
    displayName: '补课',
    sortOrder: 5,
  ),
  // 附件类型
  _PresetTag(
    category: 'attachment_file_type',
    code: 'photo',
    displayName: '照片',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'attachment_file_type',
    code: 'screenshot',
    displayName: '截图',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'attachment_file_type',
    code: 'contract',
    displayName: '合同',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'attachment_file_type',
    code: 'certificate',
    displayName: '证书',
    sortOrder: 4,
  ),
  // 附件归属类型
  _PresetTag(
    category: 'attachment_owner_type',
    code: 'class_record',
    displayName: '上课记录',
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'attachment_owner_type',
    code: 'achievement',
    displayName: '成就',
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'attachment_owner_type',
    code: 'package',
    displayName: '课包',
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'attachment_owner_type',
    code: 'payment',
    displayName: '费用',
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'attachment_owner_type',
    code: 'course',
    displayName: '课程',
    sortOrder: 5,
  ),
  // 费用类型（普通标签，可自定义）
  _PresetTag(
    category: 'payment_type',
    code: 'tuition',
    displayName: '学费',
    isSystem: false,
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'material',
    displayName: '教材费',
    isSystem: false,
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'exam',
    displayName: '考级费',
    isSystem: false,
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'competition',
    displayName: '比赛费',
    isSystem: false,
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'props',
    displayName: '道具费',
    isSystem: false,
    sortOrder: 5,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'costume',
    displayName: '服装费',
    isSystem: false,
    sortOrder: 6,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'registration',
    displayName: '报名费',
    isSystem: false,
    sortOrder: 7,
  ),
  _PresetTag(
    category: 'payment_type',
    code: 'other',
    displayName: '其他费用',
    isSystem: false,
    sortOrder: 99,
  ),
  // 成长记录类型（普通标签，可自定义）
  _PresetTag(
    category: 'achievement_type',
    code: 'competition_activity',
    displayName: '比赛/活动',
    isSystem: false,
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'award',
    displayName: '获奖',
    isSystem: false,
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'certificate',
    displayName: '证书',
    isSystem: false,
    sortOrder: 3,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'exam',
    displayName: '考级',
    isSystem: false,
    sortOrder: 4,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'performance',
    displayName: '演出',
    isSystem: false,
    sortOrder: 5,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'work',
    displayName: '作品',
    isSystem: false,
    sortOrder: 6,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'teacher_feedback',
    displayName: '老师评价',
    isSystem: false,
    sortOrder: 7,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'supplies',
    displayName: '用品/道具',
    isSystem: false,
    sortOrder: 8,
  ),
  _PresetTag(
    category: 'achievement_type',
    code: 'other',
    displayName: '其他',
    isSystem: false,
    sortOrder: 99,
  ),
  // 联系人角色（普通标签，可自定义）
  _PresetTag(
    category: 'contact_role',
    code: 'teacher',
    displayName: '老师',
    isSystem: false,
    sortOrder: 1,
  ),
  _PresetTag(
    category: 'contact_role',
    code: 'coach',
    displayName: '教练',
    isSystem: false,
    sortOrder: 2,
  ),
  _PresetTag(
    category: 'contact_role',
    code: 'advisor',
    displayName: '顾问',
    isSystem: false,
    sortOrder: 3,
  ),
];
