import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/services/schedule_occurrence_service.dart';
import 'package:class2data/features/class_records/presentation/class_record_bottom_sheet.dart';
import 'package:class2data/features/children/providers/child_providers.dart';
import 'package:class2data/features/courses/providers/course_providers.dart';
import 'package:class2data/features/home/providers/home_providers.dart';
import 'package:class2data/shared/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum _CalendarView { week, month }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late DateTime _selectedDate;
  late DateTime _weekStart;
  late PageController _pageController;
  String _courseFilter = 'all';
  bool _showMonthPicker = false;
  int _pickerYear = DateTime.now().year;
  double _monthDragDistance = 0;
  int _monthTransitionDirection = 0;

  final _quickAddMenuKey = GlobalKey(debugLabel: 'quickAddMenu');
  int? _pullPointerId;
  double _pullStartY = 0;
  bool _pullTriggered = false;
  bool _isScrollAtTop = true;

  _CalendarView _calendarView = _CalendarView.month;
  DateTime _monthViewMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime _monthSelectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  static const _initialPage = 12000;
  static final _epoch = DateTime(2024, 1, 1);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _weekStart = _startOfWeek(_selectedDate);
    _pageController = PageController(initialPage: _dateToPage(_selectedDate));
    _monthViewMonth = DateTime(now.year, now.month, 1);
    _monthSelectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _dateToPage(DateTime date) {
    return _initialPage +
        DateTime(date.year, date.month, date.day).difference(_epoch).inDays;
  }

  DateTime _pageToDate(int page) {
    final raw = _epoch.add(Duration(days: page - _initialPage));
    return DateTime(raw.year, raw.month, raw.day);
  }

  DateTime _startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  WeekRange _currentWeekRange() {
    final end = _weekStart.add(const Duration(days: 6));
    return WeekRange(
      startDate: _formatDate(_weekStart),
      endDate: _formatDate(end),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  void _shiftWeek(int direction) {
    setState(() {
      _isScrollAtTop = true;
      _weekStart = _weekStart.add(Duration(days: direction * 7));
      final dayOffset = _selectedDate.weekday - 1;
      _selectedDate = _weekStart.add(Duration(days: dayOffset));
    });
    _syncPageController();
  }

  void _selectDate(DateTime date) {
    if (date == _selectedDate) return;
    setState(() {
      _isScrollAtTop = true;
      _selectedDate = date;
      _weekStart = _startOfWeek(date);
    });
    _syncPageController();
  }

  void _goToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_calendarView == _CalendarView.week) {
      _selectDate(today);
    } else {
      setState(() {
        _monthViewMonth = DateTime(today.year, today.month, 1);
        _monthSelectedDay = today;
      });
    }
  }

  String _formatToday() {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final now = DateTime.now();
    return '${now.month}月${now.day}日 周${weekdays[now.weekday - 1]}';
  }

  void _selectMonth(int year, int month) {
    setState(() {
      _showMonthPicker = false;
      if (_calendarView == _CalendarView.week) {
        _selectedDate = DateTime(year, month, 1);
        _weekStart = _startOfWeek(_selectedDate);
        _syncPageController();
      } else {
        _monthViewMonth = DateTime(year, month, 1);
        final maxDay = DateTime(year, month + 1, 0).day;
        final day = _monthSelectedDay.day.clamp(1, maxDay);
        _monthSelectedDay = DateTime(year, month, day);
      }
    });
  }

  void _syncPageController() {
    final targetPage = _dateToPage(_selectedDate);
    if (_pageController.hasClients &&
        _pageController.page?.round() != targetPage) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  WeekRange _monthGridWeekRange(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOffset = firstDay.weekday - 1;
    final gridStart = firstDay.subtract(Duration(days: startOffset));
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final endOffset = 7 - lastDay.weekday;
    final gridEnd = lastDay.add(Duration(days: endOffset));
    return WeekRange(
      startDate: _formatDate(gridStart),
      endDate: _formatDate(gridEnd),
    );
  }

  void _shiftMonth(int direction) {
    _monthTransitionDirection = direction.sign;
    setState(() {
      _isScrollAtTop = true;
      _monthViewMonth = DateTime(
        _monthViewMonth.year,
        _monthViewMonth.month + direction,
        1,
      );
      final maxDay = DateTime(
        _monthViewMonth.year,
        _monthViewMonth.month + 1,
        0,
      ).day;
      final day = _monthSelectedDay.day.clamp(1, maxDay);
      _monthSelectedDay = DateTime(
        _monthViewMonth.year,
        _monthViewMonth.month,
        day,
      );
    });
  }

  void _handleMonthDragStart(DragStartDetails details) {
    _monthDragDistance = 0;
  }

  void _handleMonthDragUpdate(DragUpdateDetails details) {
    _monthDragDistance += details.primaryDelta ?? 0;
  }

  void _handleMonthDragEnd(DragEndDetails details) {
    const distanceThreshold = 48.0;
    const velocityThreshold = 250.0;
    final velocity = details.primaryVelocity ?? 0;

    if (velocity.abs() >= velocityThreshold) {
      _shiftMonth(velocity < 0 ? 1 : -1);
      return;
    }

    if (_monthDragDistance.abs() >= distanceThreshold) {
      _shiftMonth(_monthDragDistance < 0 ? 1 : -1);
    }
  }

  void _toggleView(_CalendarView view) {
    PageController? oldWeekCtrl;
    setState(() {
      _isScrollAtTop = true;
      if (view == _CalendarView.month && _calendarView == _CalendarView.week) {
        _monthViewMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
        _monthSelectedDay = _selectedDate;
      } else if (view == _CalendarView.week &&
          _calendarView == _CalendarView.month) {
        _selectedDate = _monthSelectedDay;
        _weekStart = _startOfWeek(_selectedDate);
        oldWeekCtrl = _pageController;
        _pageController = PageController(
          initialPage: _dateToPage(_selectedDate),
        );
      }
      _calendarView = view;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      oldWeekCtrl?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 周视图使用月网格范围，避免切换视图时数据重新加载
    final weekDataRange = _calendarView == _CalendarView.week
        ? _monthGridWeekRange(
            DateTime(_selectedDate.year, _selectedDate.month, 1),
          )
        : _currentWeekRange();
    final childrenAsync = ref.watch(activeChildrenProvider);
    final coursesAsync = ref.watch(allActiveCoursesProvider);

    final children = _unwrapChildren(childrenAsync);
    final courses = _unwrapCourses(coursesAsync);
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // 周视图数据
    final selectedDateStr = _formatDate(_selectedDate);
    final weekItemsAsync = ref.watch(weekHomeItemsProvider(weekDataRange));
    final allWeekItems =
        weekItemsAsync.whenOrNull(data: (list) => list) ?? <HomeDayItem>[];
    final filteredWeekItems = _filterItems(allWeekItems);
    final dayItems = filteredWeekItems
        .where((o) => o.date == selectedDateStr)
        .toList();
    final datesWithCourses = allWeekItems.map((o) => o.date).toSet();

    // 月视图选中日期
    final monthSelectedDateStr = _formatDate(_monthSelectedDay);

    // 月视图数据：在 build 顶层 watch，确保 Riverpod 订阅正确
    final monthGridRange = _calendarView == _CalendarView.month
        ? _monthGridWeekRange(_monthViewMonth)
        : null;
    final monthItemsAsync = monthGridRange != null
        ? ref.watch(weekHomeItemsProvider(monthGridRange))
        : null;
    final allMonthItems =
        monthItemsAsync?.whenOrNull(data: (list) => list) ?? <HomeDayItem>[];
    final filteredMonthItems = _filterItems(allMonthItems);
    final monthCourseCountByDate = <String, int>{};
    for (final item in filteredMonthItems) {
      monthCourseCountByDate[item.date] =
          (monthCourseCountByDate[item.date] ?? 0) + 1;
    }
    final monthDayItems = filteredMonthItems
        .where((o) => o.date == monthSelectedDateStr)
        .toList();
    final monthPageKey = ValueKey(_formatDate(_monthViewMonth));

    void handleRefresh() {
      ref.invalidate(weekHomeItemsProvider(weekDataRange));
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _goToToday,
          child: Text(_formatToday()),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _calendarView == _CalendarView.week
                  ? Icons.calendar_view_month
                  : Icons.view_week,
            ),
            tooltip: _calendarView == _CalendarView.week ? '月视图' : '周视图',
            onPressed: () => _toggleView(
              _calendarView == _CalendarView.week
                  ? _CalendarView.month
                  : _CalendarView.week,
            ),
          ),
          _QuickAddMenu(
            popupKey: _quickAddMenuKey,
            courses: courses,
            children: children,
            selectedDateStr: _calendarView == _CalendarView.week
                ? selectedDateStr
                : monthSelectedDateStr,
            onRefresh: handleRefresh,
          ),
        ],
      ),
      floatingActionButton: courses.isNotEmpty
          ? _CourseFilterFab(
              courses: courses,
              children: children,
              selectedFilter: _courseFilter,
              onFilterChanged: (f) => setState(() => _courseFilter = f),
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Listener(
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerCancel,
          child: Stack(
            children: [
              if (_calendarView == _CalendarView.week)
                // ─── 周视图 ───
                Column(
                  children: [
                    _MonthWeekNav(
                      selectedDate: _selectedDate,
                      onPreviousWeek: () => _shiftWeek(-1),
                      onNextWeek: () => _shiftWeek(1),
                      onToggleMonthPicker: () {
                        setState(() {
                          _showMonthPicker = !_showMonthPicker;
                          _pickerYear = _selectedDate.year;
                        });
                      },
                    ),
                    _DayInfoBar(
                      selectedDate: _selectedDate,
                      courseCount: dayItems.length,
                    ),
                    _WeekStrip(
                      weekStart: _weekStart,
                      selectedDate: _selectedDate,
                      today: today,
                      datesWithCourses: datesWithCourses,
                      onDateSelected: _selectDate,
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (page) {
                          final date = _pageToDate(page);
                          if (date != _selectedDate) {
                            setState(() {
                              _isScrollAtTop = true;
                              _selectedDate = date;
                              _weekStart = _startOfWeek(date);
                            });
                          }
                        },
                        itemBuilder: (context, index) {
                          if (weekItemsAsync.hasError) {
                            return Center(
                              child: Text('加载失败: ${weekItemsAsync.error}'),
                            );
                          }
                          final date = _pageToDate(index);
                          final dateStr = _formatDate(date);
                          final pageItems = filteredWeekItems
                              .where((o) => o.date == dateStr)
                              .toList();

                          if (pageItems.isEmpty && weekItemsAsync.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (pageItems.isEmpty) {
                            return _EmptyDayState(
                              hasCourses: filteredWeekItems.isNotEmpty,
                            );
                          }
                          return _OccurrenceList(
                            items: pageItems,
                            children: children,
                            courses: courses,
                            onRecordSaved: () => ref.invalidate(
                              weekHomeItemsProvider(weekDataRange),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              else
                // ─── 月视图 ───
                Column(
                  children: [
                    _MonthWeekNav(
                      selectedDate: _monthViewMonth,
                      onPreviousWeek: () => _shiftMonth(-1),
                      onNextWeek: () => _shiftMonth(1),
                      onToggleMonthPicker: () {
                        setState(() {
                          _showMonthPicker = !_showMonthPicker;
                          _pickerYear = _monthViewMonth.year;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onHorizontalDragStart: _handleMonthDragStart,
                        onHorizontalDragUpdate: _handleMonthDragUpdate,
                        onHorizontalDragEnd: _handleMonthDragEnd,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final incoming = child.key == monthPageKey;
                            final direction = _monthTransitionDirection;
                            final begin = direction == 0
                                ? Offset.zero
                                : Offset(
                                    incoming
                                        ? direction.toDouble()
                                        : -direction.toDouble(),
                                    0,
                                  );
                            final curved = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            );
                            return FadeTransition(
                              opacity: curved,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: begin,
                                  end: Offset.zero,
                                ).animate(curved),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: monthPageKey,
                            children: [
                              _buildWeekdayHeader(context),
                              _MonthCalendarGrid(
                                month: _monthViewMonth,
                                selectedDay: _monthSelectedDay,
                                today: today,
                                courseCountByDate: monthCourseCountByDate,
                                onDaySelected: (date) {
                                  setState(() => _monthSelectedDay = date);
                                },
                              ),
                              const Divider(height: 1),
                              _DayInfoBar(
                                selectedDate: _monthSelectedDay,
                                courseCount: monthDayItems.length,
                              ),
                              Expanded(
                                child: monthItemsAsync?.hasError == true
                                    ? Center(
                                        child: Text(
                                          '加载失败: ${monthItemsAsync!.error}',
                                        ),
                                      )
                                    : monthDayItems.isEmpty &&
                                          monthItemsAsync?.isLoading != true
                                    ? _EmptyDayState(
                                        hasCourses:
                                            filteredMonthItems.isNotEmpty,
                                      )
                                    : monthItemsAsync?.isLoading == true
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : _OccurrenceList(
                                        items: monthDayItems,
                                        children: children,
                                        courses: courses,
                                        onRecordSaved: () => ref.invalidate(
                                          weekHomeItemsProvider(
                                            monthGridRange!,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              // 月份选择器浮层
              if (_showMonthPicker) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _showMonthPicker = false),
                  child: const SizedBox.expand(),
                ),
                Positioned(
                  top: 0,
                  left: 16,
                  right: 16,
                  child: _MonthPickerPopup(
                    pickerYear: _pickerYear,
                    selectedDate: _calendarView == _CalendarView.week
                        ? _selectedDate
                        : _monthViewMonth,
                    onYearChanged: (y) => setState(() => _pickerYear = y),
                    onMonthSelected: _selectMonth,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: weekdays
            .map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<ChildrenData> _unwrapChildren(
    AsyncValue<Result<List<ChildrenData>>> async,
  ) {
    return async.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value,
            Err() => <ChildrenData>[],
          },
        ) ??
        <ChildrenData>[];
  }

  List<KidCourse> _unwrapCourses(AsyncValue<Result<List<KidCourse>>> async) {
    return async.whenOrNull(
          data: (result) => switch (result) {
            Ok(:final value) => value,
            Err() => <KidCourse>[],
          },
        ) ??
        <KidCourse>[];
  }

  List<HomeDayItem> _filterItems(List<HomeDayItem> items) {
    if (_courseFilter == 'all') return items;
    final courseId = int.tryParse(_courseFilter);
    if (courseId == null) return items;
    return items.where((o) => o.kidCourseId == courseId).toList();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _isScrollAtTop = notification.metrics.pixels <= 0;
    }
    return false;
  }

  void _handlePointerDown(PointerDownEvent event) {
    _pullPointerId = event.pointer;
    _pullStartY = event.position.dy;
    _pullTriggered = false;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _pullPointerId || _pullTriggered || !_isScrollAtTop) {
      return;
    }
    final dy = event.position.dy - _pullStartY;
    if (dy > 100) {
      _pullTriggered = true;
      _showQuickAddMenu();
    }
  }

  void _handlePointerUp(PointerEvent event) {
    if (event.pointer == _pullPointerId) {
      _pullPointerId = null;
    }
  }

  void _handlePointerCancel(PointerEvent event) {
    if (event.pointer == _pullPointerId) {
      _pullPointerId = null;
    }
  }

  void _showQuickAddMenu() {
    final state = _quickAddMenuKey.currentState;
    if (state != null) {
      (state as dynamic).showButtonMenu();
    }
  }
}

// ─── 快捷添加菜单 ───

class _QuickAddMenu extends ConsumerWidget {
  final Key? popupKey;
  final List<KidCourse> courses;
  final List<ChildrenData> children;
  final String selectedDateStr;
  final VoidCallback onRefresh;

  const _QuickAddMenu({
    this.popupKey,
    required this.courses,
    required this.children,
    required this.selectedDateStr,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      key: popupKey,
      icon: const Icon(Icons.add),
      tooltip: '快捷操作',
      onSelected: (value) async {
        switch (value) {
          case 'record':
            await _openQuickRecord(context, ref);
          case 'package':
            await _openQuickPackage(context);
          case 'course':
            final newCourseId = await context.push<int>('/courses/add');
            if (newCourseId != null && context.mounted) {
              await context.push('/courses/$newCourseId');
            }
          case 'achievement':
            await _openQuickAchievement(context);
          case 'child':
            await context.push('/children/add');
          case 'courseManage':
            if (context.mounted) {
              await context.push('/course-manage');
            }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'record',
          child: Row(
            children: [
              Icon(Icons.edit_note, size: 20),
              SizedBox(width: 12),
              Text('记录上课', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'achievement',
          child: Row(
            children: [
              Icon(Icons.emoji_events_outlined, size: 20),
              SizedBox(width: 12),
              Text('记录成长'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'course',
          child: Row(
            children: [
              Icon(Icons.school_outlined, size: 20),
              SizedBox(width: 12),
              Text('录入课程'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'package',
          child: Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 20),
              SizedBox(width: 12),
              Text('录入课时包'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'child',
          child: Row(
            children: [
              Icon(Icons.child_care_outlined, size: 20),
              SizedBox(width: 12),
              Text('录入孩子'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'courseManage',
          child: Row(
            children: [
              Icon(Icons.manage_accounts_outlined, size: 20),
              SizedBox(width: 12),
              Text('课程管理'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openQuickRecord(BuildContext context, WidgetRef ref) async {
    if (courses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加课程')));
      return;
    }
    final selected = await showDialog<KidCourse>(
      context: context,
      builder: (ctx) => _SimplePickerDialog<KidCourse>(
        title: '选择课程',
        items: courses,
        labelBuilder: (c) {
          final child = children.where((ch) => ch.id == c.childId).firstOrNull;
          return child != null ? '${c.name} · ${child.name}' : c.name;
        },
      ),
    );
    if (selected == null || !context.mounted) return;

    final now = DateTime.now();
    final occurrence = ScheduleOccurrence(
      scheduleId: -1,
      kidCourseId: selected.id,
      date: selectedDateStr,
      startTime: DateFormat('HH:mm').format(now),
      endTime: DateFormat('HH:mm').format(now.add(const Duration(hours: 1))),
      occurrenceKey:
          'manual_${selected.id}_${selectedDateStr}_${now.millisecondsSinceEpoch}',
      classType: null,
      classNameSnapshot: selected.name,
    );

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ClassRecordBottomSheet(occurrence: occurrence),
    );
    if (saved == true) onRefresh();
  }

  Future<void> _openQuickPackage(BuildContext context) async {
    if (courses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加课程')));
      return;
    }
    final selected = await showDialog<KidCourse>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择课程'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: courses.map((c) {
              final child = children
                  .where((ch) => ch.id == c.childId)
                  .firstOrNull;
              return ListTile(
                leading: child != null
                    ? ChildAvatar(
                        name: child.name,
                        avatarPath: child.avatarPath,
                        radius: 16,
                      )
                    : null,
                title: Text(c.name),
                subtitle: child != null ? Text(child.name) : null,
                onTap: () => Navigator.pop(ctx, c),
              );
            }).toList(),
          ),
        ),
      ),
    );
    if (selected != null && context.mounted) {
      await context.push('/courses/${selected.id}/packages/add');
    }
  }

  Future<void> _openQuickAchievement(BuildContext context) async {
    if (children.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加孩子')));
      return;
    }
    ChildrenData? selected;
    if (children.length == 1) {
      selected = children.first;
    } else {
      selected = await showDialog<ChildrenData>(
        context: context,
        builder: (ctx) => _ChildPickerDialog(children: children),
      );
    }
    if (selected != null && context.mounted) {
      await context.push('/children/${selected.id}/achievements/add');
    }
  }
}

// ─── 通用选择对话框 ───

class _SimplePickerDialog<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final String Function(T) labelBuilder;

  const _SimplePickerDialog({
    required this.title,
    required this.items,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .map(
                (item) => ListTile(
                  title: Text(labelBuilder(item)),
                  onTap: () => Navigator.pop(context, item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ChildPickerDialog extends StatelessWidget {
  final List<ChildrenData> children;

  const _ChildPickerDialog({required this.children});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择孩子'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children
              .map(
                (child) => ListTile(
                  leading: ChildAvatar(
                    name: child.name,
                    avatarPath: child.avatarPath,
                    radius: 18,
                  ),
                  title: Text(child.name),
                  onTap: () => Navigator.pop(context, child),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ─── 月份/周导航 ───

class _MonthWeekNav extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onToggleMonthPicker;

  const _MonthWeekNav({
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onToggleMonthPicker,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 18),
              onPressed: onPreviousWeek,
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onToggleMonthPicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${selectedDate.year}年${selectedDate.month}月',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              icon: const Icon(Icons.chevron_right, size: 18),
              onPressed: onNextWeek,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 日期信息栏 ───

class _DayInfoBar extends StatelessWidget {
  final DateTime selectedDate;
  final int courseCount;

  const _DayInfoBar({required this.selectedDate, required this.courseCount});

  static const _weekLabels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '周${_weekLabels[selectedDate.weekday - 1]} · '
            '${selectedDate.month}月${selectedDate.day}日',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            courseCount > 0 ? '$courseCount 节课程' : '无课程',
            style: TextStyle(
              fontSize: 12,
              color: courseCount > 0
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 月份选择器 ───

class _MonthPickerPopup extends StatelessWidget {
  final int pickerYear;
  final DateTime selectedDate;
  final ValueChanged<int> onYearChanged;
  final void Function(int year, int month) onMonthSelected;

  const _MonthPickerPopup({
    required this.pickerYear,
    required this.selectedDate,
    required this.onYearChanged,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 16),
                  onPressed: () => onYearChanged(pickerYear - 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                Text(
                  '$pickerYear年',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 16),
                  onPressed: () => onYearChanged(pickerYear + 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
              children: List.generate(12, (i) {
                final isActive =
                    pickerYear == selectedDate.year &&
                    i + 1 == selectedDate.month;
                return GestureDetector(
                  onTap: () => onMonthSelected(pickerYear, i + 1),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? theme.colorScheme.primaryContainer
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}月',
                        style: TextStyle(
                          fontSize: 13,
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: isActive ? FontWeight.w500 : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 课程筛选 FAB ───

class _CourseFilterFab extends StatelessWidget {
  final List<KidCourse> courses;
  final List<ChildrenData> children;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _CourseFilterFab({
    required this.courses,
    required this.children,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered = selectedFilter != 'all';
    final selectedCourse = isFiltered
        ? courses.where((c) => c.id.toString() == selectedFilter).firstOrNull
        : null;

    return FloatingActionButton.small(
      onPressed: () => _showFilterSheet(context),
      tooltip: selectedCourse != null ? selectedCourse.name : '筛选课程',
      backgroundColor: isFiltered
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHigh,
      foregroundColor: isFiltered
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
      child: Icon(
        isFiltered ? Icons.filter_list : Icons.filter_list_outlined,
        size: 20,
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => _CourseFilterSheet(
        courses: courses,
        children: children,
        selectedFilter: selectedFilter,
      ),
    );
    if (result != null) {
      onFilterChanged(result);
    }
  }
}

class _CourseFilterSheet extends StatelessWidget {
  final List<KidCourse> courses;
  final List<ChildrenData> children;
  final String selectedFilter;

  const _CourseFilterSheet({
    required this.courses,
    required this.children,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text(
                    '筛选课程',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'all'),
                    child: const Text('全部'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final child = children
                      .where((c) => c.id == course.childId)
                      .firstOrNull;
                  final isSelected = course.id.toString() == selectedFilter;

                  return ListTile(
                    leading: ChildAvatar(
                      name: child?.name ?? '?',
                      avatarPath: child?.avatarPath,
                      radius: 16,
                    ),
                    title: Text(course.name),
                    subtitle: child != null ? Text(child.name) : null,
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.pop(context, course.id.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 周视图 ───

class _WeekStrip extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selectedDate;
  final DateTime today;
  final Set<String> datesWithCourses;
  final ValueChanged<DateTime> onDateSelected;

  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  const _WeekStrip({
    required this.weekStart,
    required this.selectedDate,
    required this.today,
    required this.datesWithCourses,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Row(
        children: List.generate(7, (i) {
          final date = weekStart.add(Duration(days: i));
          final dateStr =
              '${date.year.toString().padLeft(4, '0')}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}';
          final isSelected = date == selectedDate;
          final isToday = date == today;
          final hasCourse = datesWithCourses.contains(dateStr);

          return Expanded(
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Text(
                      _weekdays[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected || isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // 选中态：蓝色底线；非选中但有课程：蓝色圆点
                    Container(
                      width: isSelected ? 16 : 4,
                      height: isSelected ? 2 : 4,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : hasCourse
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(isSelected ? 1 : 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── 空状态 ───

class _EmptyDayState extends StatelessWidget {
  final bool hasCourses;

  const _EmptyDayState({required this.hasCourses});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hasCourses ? '今天没有课' : '还没有课程',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

// ─── 课程列表 ───

class _OccurrenceList extends StatelessWidget {
  final List<HomeDayItem> items;
  final List<ChildrenData> children;
  final List<KidCourse> courses;
  final VoidCallback? onRecordSaved;

  static const _statusLabels = {
    'attended': '已上课',
    'leave': '请假',
    'cancelled': '取消',
    'absent': '缺课',
    'makeup': '补课',
  };

  const _OccurrenceList({
    required this.items,
    required this.children,
    required this.courses,
    this.onRecordSaved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final course = courses
            .where((c) => c.id == item.kidCourseId)
            .firstOrNull;
        final child = course != null
            ? children.where((c) => c.id == course.childId).firstOrNull
            : null;

        final statusLabel = item.isRecorded
            ? (_statusLabels[item.recordStatus] ?? '已记录')
            : (item.hasAvailablePackage ? '待记录' : '无课包');

        final statusColor = _statusColor(theme, item);

        return InkWell(
          onTap: () async {
            if (item.isRecorded) {
              await context.push('/class-records/${item.recordId}');
              onRecordSaved?.call();
            } else if (item.isPending) {
              final occ = ScheduleOccurrence(
                scheduleId: item.scheduleId,
                kidCourseId: item.kidCourseId,
                date: item.date,
                startTime: item.startTime,
                endTime: item.endTime,
                occurrenceKey: item.occurrenceKey,
                classType: item.classType,
                classNameSnapshot: item.classNameSnapshot,
              );
              final saved = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (_) => ClassRecordBottomSheet(occurrence: occ),
              );
              if (saved == true) onRecordSaved?.call();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.startTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        item.endTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (child != null) ...[
                  ChildAvatar(
                    name: child.name,
                    avatarPath: child.avatarPath,
                    radius: 18,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.classNameSnapshot ?? course?.name ?? '课程',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.packageTypeLabel != null ||
                              item.remainingCreditsLabel != null) ...[
                            const SizedBox(width: 6),
                            if (item.packageTypeLabel != null)
                              _PackageTag(
                                text: item.packageTypeLabel!,
                                color: theme.colorScheme.secondaryContainer,
                                textColor:
                                    theme.colorScheme.onSecondaryContainer,
                              ),
                            if (item.packageTypeLabel != null &&
                                item.remainingCreditsLabel != null)
                              const SizedBox(width: 4),
                            if (item.remainingCreditsLabel != null)
                              _PackageTag(
                                text: item.remainingCreditsLabel!,
                                color: theme.colorScheme.tertiaryContainer,
                                textColor:
                                    theme.colorScheme.onTertiaryContainer,
                              ),
                          ],
                        ],
                      ),
                      if (course != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${course.institutionName}${course.location != null && course.location!.isNotEmpty ? ' · ${course.location}' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: _statusTextColor(theme, item),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(ThemeData theme, HomeDayItem item) {
    if (item.isPending && !item.hasAvailablePackage) {
      return theme.colorScheme.errorContainer;
    }
    if (item.isPending) return theme.colorScheme.tertiaryContainer;
    return switch (item.recordStatus) {
      'attended' => const Color(0xFFDCFCE7),
      'leave' => const Color(0xFFF3F4F6),
      'cancelled' => const Color(0xFFF3F4F6),
      'absent' => const Color(0xFFFEE2E2),
      'makeup' => const Color(0xFFDBEAFE),
      _ => theme.colorScheme.tertiaryContainer,
    };
  }

  Color _statusTextColor(ThemeData theme, HomeDayItem item) {
    if (item.isPending && !item.hasAvailablePackage) {
      return theme.colorScheme.onErrorContainer;
    }
    if (item.isPending) return theme.colorScheme.onTertiaryContainer;
    return switch (item.recordStatus) {
      'attended' => const Color(0xFF166534),
      'leave' => const Color(0xFF6B7280),
      'cancelled' => const Color(0xFF6B7280),
      'absent' => const Color(0xFF991B1B),
      'makeup' => const Color(0xFF1E40AF),
      _ => theme.colorScheme.onTertiaryContainer,
    };
  }
}

class _PackageTag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _PackageTag({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, color: textColor)),
    );
  }
}

// ─── 月视图日历网格 ───

class _MonthCalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDay;
  final DateTime today;
  final Map<String, int> courseCountByDate;
  final ValueChanged<DateTime> onDaySelected;

  const _MonthCalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.today,
    required this.courseCountByDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final firstDay = DateTime(month.year, month.month, 1);
    final startOffset = firstDay.weekday - 1;
    final gridStart = firstDay.subtract(Duration(days: startOffset));
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final endOffset = 7 - lastDay.weekday;
    final gridEnd = lastDay.add(Duration(days: endOffset));

    final dates = <DateTime>[];
    for (
      var d = gridStart;
      !d.isAfter(gridEnd);
      d = d.add(const Duration(days: 1))
    ) {
      dates.add(DateTime(d.year, d.month, d.day));
    }
    final rows = dates.length ~/ 7;

    return Column(
      children: List.generate(rows, (row) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(7, (col) {
              final date = dates[row * 7 + col];
              final dateStr =
                  '${date.year.toString().padLeft(4, '0')}-'
                  '${date.month.toString().padLeft(2, '0')}-'
                  '${date.day.toString().padLeft(2, '0')}';
              final isCurrentMonth = date.month == month.month;
              final isSelected = date == selectedDay;
              final isToday = date == today;
              final courseCount = courseCountByDate[dateStr] ?? 0;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => onDaySelected(date),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : isToday
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  )
                                : null,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : isCurrentMonth
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (courseCount > 0)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 1.5,
                            runSpacing: 1,
                            children: List.generate(
                              courseCount,
                              (_) => Container(
                                width: 3.5,
                                height: 3.5,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : isCurrentMonth
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
