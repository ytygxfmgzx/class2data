import 'package:class2data/core/result/result.dart';
import 'package:class2data/features/achievements/presentation/achievement_form_page.dart';
import 'package:class2data/features/achievements/providers/achievement_providers.dart';
import 'package:class2data/features/backup/presentation/backup_page.dart';
import 'package:class2data/features/backup/presentation/export_page.dart';
import 'package:class2data/features/cloud_backup/presentation/webdav_config_page.dart';
import 'package:class2data/features/cloud_backup/presentation/cloud_backup_page.dart';
import 'package:class2data/features/cloud_backup/providers/webdav_config_providers.dart';
import 'package:class2data/features/feedback/presentation/appreciation_page.dart';
import 'package:class2data/features/feedback/presentation/feedback_page.dart';
import 'package:class2data/features/children/presentation/child_form_page.dart';
import 'package:class2data/features/children/presentation/child_list_page.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/class_records/presentation/class_record_detail_page.dart';
import 'package:class2data/features/class_records/presentation/class_record_edit_page.dart';
import 'package:class2data/features/contacts/presentation/contact_form_page.dart';
import 'package:class2data/features/courses/presentation/course_detail_page.dart';
import 'package:class2data/features/courses/presentation/course_form_page.dart';
import 'package:class2data/features/courses/presentation/course_manage_page.dart';
import 'package:class2data/features/courses/presentation/plan_manage_page.dart';
import 'package:class2data/features/courses/presentation/schedule_form_page.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/credit_ledger/presentation/credit_adjustment_form_page.dart';
import 'package:class2data/features/credit_ledger/presentation/credit_ledger_page.dart';
import 'package:class2data/features/growth/presentation/child_timeline_page.dart';
import 'package:class2data/features/growth/presentation/growth_page.dart';
import 'package:class2data/features/growth/presentation/growth_statistics_page.dart';
import 'package:class2data/features/growth/presentation/photo_wall_page.dart';
import 'package:class2data/features/home/presentation/home_page.dart';
import 'package:class2data/features/packages/presentation/package_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/growth',
            name: 'growth',
            builder: (context, state) => const GrowthPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const _SettingsPage(),
          ),
        ],
      ),
      // 孩子
      GoRoute(
        path: '/children',
        name: 'children',
        builder: (context, state) => const ChildListPage(),
      ),
      GoRoute(
        path: '/children/add',
        name: 'addChild',
        builder: (context, state) => const ChildFormPage(),
      ),
      GoRoute(
        path: '/children/:id/edit',
        name: 'editChild',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChildFormPage(childId: id);
        },
      ),
      // 课程
      GoRoute(
        path: '/courses/add',
        name: 'addCourse',
        builder: (context, state) {
          final childId = int.tryParse(
            state.uri.queryParameters['childId'] ?? '',
          );
          return CourseFormPage(childId: childId);
        },
      ),
      GoRoute(
        path: '/courses/:id',
        name: 'courseDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '');
          return CourseDetailPage(courseId: id, initialTab: tab ?? 0);
        },
      ),
      GoRoute(
        path: '/courses/:id/edit',
        name: 'editCourse',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CourseFormPage(courseId: id);
        },
      ),
      // 联系人
      GoRoute(
        path: '/courses/:courseId/contacts/add',
        name: 'addContact',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          return ContactFormPage(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/contacts/:contactId/edit',
        name: 'editContact',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          final contactId = int.parse(state.pathParameters['contactId']!);
          return ContactFormPage(courseId: courseId, contactId: contactId);
        },
      ),
      // 上课计划
      GoRoute(
        path: '/courses/:courseId/schedules/add',
        name: 'addSchedule',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          return ScheduleFormPage(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/schedules/:scheduleId/edit',
        name: 'editSchedule',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          final scheduleId = int.parse(state.pathParameters['scheduleId']!);
          return ScheduleFormPage(courseId: courseId, scheduleId: scheduleId);
        },
      ),
      // 课包
      GoRoute(
        path: '/courses/:courseId/packages/add',
        name: 'addPackage',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          return PackageFormPage(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/courses/:courseId/packages/:packageId/edit',
        name: 'editPackage',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          final packageId = int.parse(state.pathParameters['packageId']!);
          return PackageFormPage(courseId: courseId, packageId: packageId);
        },
      ),
      // 课时明细
      GoRoute(
        path: '/courses/:courseId/credit-ledger',
        name: 'creditLedger',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          return CreditLedgerPage(courseId: courseId);
        },
      ),
      // 课时手动调整
      GoRoute(
        path: '/courses/:courseId/credit-adjust',
        name: 'creditAdjust',
        builder: (context, state) {
          final courseId = int.parse(state.pathParameters['courseId']!);
          return CreditAdjustmentFormPage(courseId: courseId);
        },
      ),
      // 上课记录详情
      GoRoute(
        path: '/class-records/:id',
        name: 'classRecordDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ClassRecordDetailPage(recordId: id);
        },
      ),
      // 编辑上课记录
      GoRoute(
        path: '/class-records/:id/edit',
        name: 'classRecordEdit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ClassRecordEditPage(recordId: id);
        },
      ),
      // 成就
      GoRoute(
        path: '/children/:childId/achievements/add',
        name: 'addAchievement',
        builder: (context, state) {
          final childId = int.parse(state.pathParameters['childId']!);
          final courseId = int.tryParse(
            state.uri.queryParameters['courseId'] ?? '',
          );
          return AchievementFormPage(childId: childId, courseId: courseId);
        },
      ),
      // 孩子时间线
      GoRoute(
        path: '/children/:childId/timeline',
        name: 'childTimeline',
        builder: (context, state) {
          final childId = int.parse(state.pathParameters['childId']!);
          return ChildTimelinePage(childId: childId);
        },
      ),
      // 照片墙
      GoRoute(
        path: '/children/:childId/photos',
        name: 'photoWall',
        builder: (context, state) {
          final childId = int.parse(state.pathParameters['childId']!);
          return PhotoWallPage(childId: childId);
        },
      ),
      GoRoute(
        path: '/achievements/:id/edit',
        name: 'editAchievement',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          // 需要从 provider 加载成就信息获取 childId
          return _AchievementEditWrapper(achievementId: id);
        },
      ),
      // 备份与恢复
      GoRoute(
        path: '/backup',
        name: 'backup',
        builder: (context, state) => const BackupPage(),
      ),
      // WebDAV 配置
      GoRoute(
        path: '/cloud-backup/config',
        name: 'cloudBackupConfig',
        builder: (context, state) => const WebDavConfigPage(),
      ),
      // 云端备份与恢复
      GoRoute(
        path: '/cloud-backup',
        name: 'cloudBackup',
        builder: (context, state) => const CloudBackupPage(),
      ),
      // 课程管理
      GoRoute(
        path: '/course-manage',
        name: 'courseManage',
        builder: (context, state) => const CourseManagePage(),
      ),
      // 课程计划维护
      GoRoute(
        path: '/plan-manage',
        name: 'planManage',
        builder: (context, state) => const PlanManagePage(),
      ),
      // 导出
      GoRoute(
        path: '/export',
        name: 'export',
        builder: (context, state) => const ExportPage(),
      ),
      // 统计
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const GrowthStatisticsPage(),
      ),
      // 赞赏
      GoRoute(
        path: '/appreciation',
        name: 'appreciation',
        builder: (context, state) => const AppreciationPage(),
      ),
      // 意见反馈
      GoRoute(
        path: '/feedback',
        name: 'feedback',
        builder: (context, state) => const FeedbackPage(),
      ),
    ],
  );
});

class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const _BottomNav());
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return NavigationBar(
      selectedIndex: _currentIndex(location),
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/growth');
          case 2:
            context.go('/settings');
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: '上课'),
        NavigationDestination(icon: Icon(Icons.bar_chart), label: '成长'),
        NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
      ],
    );
  }

  int _currentIndex(String location) {
    if (location.startsWith('/growth')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }
}

class _SettingsPage extends ConsumerWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(activeChildrenProvider);
    final coursesAsync = ref.watch(allActiveCoursesProvider);

    final childCount =
        childrenAsync.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value.length,
            Err() => 0,
          },
        ) ??
        0;

    final courseCount =
        coursesAsync.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value.length,
            Err() => 0,
          },
        ) ??
        0;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _SettingsGroup(
            title: '数据管理',
            children: [
              _SettingsRow(
                icon: Icons.child_care,
                title: '孩子管理',
                value: childCount > 0 ? '$childCount 个孩子' : null,
                onTap: () => context.push('/children'),
              ),
              _SettingsRow(
                icon: Icons.school,
                title: '课程管理',
                value: courseCount > 0 ? '$courseCount 门课程' : null,
                onTap: () => context.push('/course-manage'),
              ),
              _SettingsRow(
                icon: Icons.list,
                title: '课程计划维护',
                onTap: () => context.push('/plan-manage'),
              ),
            ],
          ),
          _SettingsGroup(
            title: '数据安全',
            children: [
              _SettingsRow(
                icon: Icons.shield,
                title: '本地备份与恢复',
                value: '建议每月备份',
                onTap: () => context.push('/backup'),
              ),
              _SettingsRow(
                icon: Icons.cloud_outlined,
                title: '云端备份与恢复',
                value: '通过 WebDAV 同步',
                onTap: () async {
                  await ref
                      .read(webDavConfigProvider.notifier)
                      .loaded;
                  if (!context.mounted) return;
                  final config = ref.read(webDavConfigProvider);
                  if (config.isConfigured) {
                    context.push('/cloud-backup');
                  } else {
                    context.push('/cloud-backup/config');
                  }
                },
              ),
            ],
          ),
          _SettingsGroup(
            title: '关于',
            children: [
              _SettingsRow(
                icon: Icons.local_cafe_outlined,
                title: '请开发者喝茶',
                onTap: () => context.push('/appreciation'),
              ),
              _SettingsRow(
                icon: Icons.feedback_outlined,
                title: '意见反馈',
                onTap: () => context.push('/feedback'),
              ),
              _SettingsRow(
                icon: Icons.info,
                title: '版本',
                value: 'v0.1.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
            if (value != null)
              Text(
                value!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (value == null)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

class _AchievementEditWrapper extends ConsumerWidget {
  final int achievementId;

  const _AchievementEditWrapper({required this.achievementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async_ = ref.watch(achievementByIdProvider(achievementId));

    return async_.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('错误')),
        body: Center(child: Text('加载失败: $e')),
      ),
      data: (achievement) {
        if (achievement == null) {
          return const Scaffold(body: Center(child: Text('成长记录不存在')));
        }
        return AchievementFormPage(
          childId: achievement.childId,
          courseId: achievement.kidCourseId,
          achievementId: achievement.id,
        );
      },
    );
  }
}
