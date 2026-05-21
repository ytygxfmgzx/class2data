import 'dart:math';

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
      _weekStart = _weekStart.add(Duration(days: direction * 7));
      final dayOffset = _selectedDate.weekday - 1;
      _selectedDate = _weekStart.add(Duration(days: dayOffset));
    });
    _syncPageController();
  }

  void _selectDate(DateTime date) {
    if (date == _selectedDate) return;
    setState(() {
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 周视图数据
    final selectedDateStr = _formatDate(_selectedDate);
    final weekItemsAsync = ref.watch(weekHomeItemsProvider(weekDataRange));
    final allWeekItems =
        weekItemsAsync.whenOrNull(data: (list) => list) ?? <HomeDayItem>[];
    final filteredWeekItems = _filterItems(allWeekItems);
    final dayItems = filteredWeekItems
        .where((o) => o.date == selectedDateStr)
        .toList();
    final weekDotStatesByDate = <String, List<CalendarDotColor>>{};
    for (final item in allWeekItems) {
      weekDotStatesByDate
          .putIfAbsent(item.date, () => [])
          .add(item.calendarDotState(now));
    }

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
    final monthDotStatesByDate = <String, List<CalendarDotColor>>{};
    for (final item in filteredMonthItems) {
      monthDotStatesByDate
          .putIfAbsent(item.date, () => [])
          .add(item.calendarDotState(now));
    }
    final monthDayItems = filteredMonthItems
        .where((o) => o.date == monthSelectedDateStr)
        .toList();
    final monthPageKey = ValueKey(_formatDate(_monthViewMonth));

    void handleRefresh() {
      ref.read(homeDataVersionProvider.notifier).state++;
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
        ],
      ),
      floatingActionButton: _HomeFabGroup(
        courses: courses,
        children: children,
        selectedDateStr: _calendarView == _CalendarView.week
            ? selectedDateStr
            : monthSelectedDateStr,
        onRefresh: handleRefresh,
        courseFilter: _courseFilter,
        onFilterChanged: (f) => setState(() => _courseFilter = f),
      ),
      body: Stack(
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
                  dotStatesByDate: weekDotStatesByDate,
                  onDateSelected: _selectDate,
                ),
                const _CalendarLegend(),
                const Divider(height: 1),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      final date = _pageToDate(page);
                      if (date != _selectedDate) {
                        setState(() {
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
                        return const Center(child: CircularProgressIndicator());
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
                        now: now,
                        onRecordSaved: () =>
                            ref.read(homeDataVersionProvider.notifier).state++,
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
                            dotStatesByDate: monthDotStatesByDate,
                            onDaySelected: (date) {
                              setState(() => _monthSelectedDay = date);
                            },
                          ),
                          const _CalendarLegend(),
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
                                    hasCourses: filteredMonthItems.isNotEmpty,
                                  )
                                : monthItemsAsync?.isLoading == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _OccurrenceList(
                                    items: monthDayItems,
                                    children: children,
                                    courses: courses,
                                    now: now,
                                    onRecordSaved: () => ref
                                        .read(homeDataVersionProvider.notifier)
                                        .state++,
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
}

// ─── 首页浮层按钮组 ───

class _HomeFabGroup extends StatefulWidget {
  final List<KidCourse> courses;
  final List<ChildrenData> children;
  final String selectedDateStr;
  final VoidCallback onRefresh;
  final String courseFilter;
  final ValueChanged<String> onFilterChanged;

  const _HomeFabGroup({
    required this.courses,
    required this.children,
    required this.selectedDateStr,
    required this.onRefresh,
    required this.courseFilter,
    required this.onFilterChanged,
  });

  @override
  State<_HomeFabGroup> createState() => _HomeFabGroupState();
}

class _HomeFabGroupState extends State<_HomeFabGroup>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _close() {
    if (!_isExpanded) return;
    setState(() => _isExpanded = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildDialItems();

    final children = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final delay = (items.length - 1 - i) / items.length;
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _DialChild(
            animation: CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
            ),
            label: items[i].label,
            icon: items[i].icon,
            onTap: () {
              _close();
              items[i].onTap();
            },
          ),
        ),
      );
    }

    // 主 FAB（+ 按钮）
    children.add(
      FloatingActionButton(
        onPressed: _toggle,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 0.75 * pi,
              child: child,
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );

    // 筛选按钮在主 FAB 下方，大小一致
    if (widget.courses.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _CourseFilterFab(
            courses: widget.courses,
            children: widget.children,
            selectedFilter: widget.courseFilter,
            onFilterChanged: widget.onFilterChanged,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }

  List<_DialItemData> _buildDialItems() {
    return [
      _DialItemData(
        label: '课程管理',
        icon: Icons.manage_accounts_outlined,
        onTap: () => context.push('/course-manage'),
      ),
      _DialItemData(
        label: '录入孩子',
        icon: Icons.child_care_outlined,
        onTap: () => context.push('/children/add'),
      ),
      _DialItemData(
        label: '录入课时包',
        icon: Icons.inventory_2_outlined,
        onTap: () => _openQuickPackage(),
      ),
      _DialItemData(
        label: '录入课程',
        icon: Icons.school_outlined,
        onTap: () async {
          final newCourseId = await context.push<int>('/courses/add');
          if (newCourseId != null && context.mounted) {
            await context.push('/courses/$newCourseId');
          }
        },
      ),
      _DialItemData(
        label: '记录成长',
        icon: Icons.emoji_events_outlined,
        onTap: () => _openQuickAchievement(),
      ),
      _DialItemData(
        label: '记录上课',
        icon: Icons.edit_note,
        onTap: () => _openQuickRecord(),
      ),
    ];
  }

  Future<void> _openQuickRecord() async {
    if (widget.courses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加课程')));
      return;
    }
    final selected = await _showUnifiedBottomSheet<KidCourse>(
      context: context,
      title: '选择课程',
      items: widget.courses,
      itemBuilder: (c) {
        final child = widget.children
            .where((ch) => ch.id == c.childId)
            .firstOrNull;
        return ListTile(
          leading: child != null
              ? ChildAvatar(
                  name: child.name,
                  avatarPath: child.avatarPath,
                  radius: 18,
                )
              : null,
          title: Text(
            child != null ? '${child.name} · ${c.name}' : c.name,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => Navigator.pop(context, c),
        );
      },
    );
    if (selected == null || !context.mounted) return;

    final now = DateTime.now();
    final occurrence = ScheduleOccurrence(
      scheduleId: -1,
      kidCourseId: selected.id,
      date: widget.selectedDateStr,
      startTime: DateFormat('HH:mm').format(now),
      endTime: DateFormat('HH:mm').format(now.add(const Duration(hours: 1))),
      occurrenceKey:
          'manual_${selected.id}_${widget.selectedDateStr}_${now.millisecondsSinceEpoch}',
      classType: null,
      classNameSnapshot: selected.name,
    );

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ClassRecordBottomSheet(occurrence: occurrence),
    );
    if (saved == true) widget.onRefresh();
  }

  Future<void> _openQuickPackage() async {
    if (widget.courses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加课程')));
      return;
    }
    final selected = await _showUnifiedBottomSheet<KidCourse>(
      context: context,
      title: '选择课程',
      items: widget.courses,
      itemBuilder: (c) {
        final child = widget.children
            .where((ch) => ch.id == c.childId)
            .firstOrNull;
        return ListTile(
          leading: child != null
              ? ChildAvatar(
                  name: child.name,
                  avatarPath: child.avatarPath,
                  radius: 18,
                )
              : null,
          title: Text(
            child != null ? '${child.name} · ${c.name}' : c.name,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => Navigator.pop(context, c),
        );
      },
    );
    if (selected != null && context.mounted) {
      await context.push('/courses/${selected.id}/packages/add');
    }
  }

  Future<void> _openQuickAchievement() async {
    if (widget.children.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加孩子')));
      return;
    }
    ChildrenData? selected;
    if (widget.children.length == 1) {
      selected = widget.children.first;
    } else {
      selected = await _showUnifiedBottomSheet<ChildrenData>(
        context: context,
        title: '选择孩子',
        items: widget.children,
        itemBuilder: (child) => ListTile(
          leading: ChildAvatar(
            name: child.name,
            avatarPath: child.avatarPath,
            radius: 18,
          ),
          title: Text(child.name, overflow: TextOverflow.ellipsis),
          onTap: () => Navigator.pop(context, child),
        ),
      );
    }
    if (selected != null && context.mounted) {
      await context.push('/children/${selected.id}/achievements/add');
    }
  }
}

class _DialItemData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DialItemData({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class _DialChild extends StatelessWidget {
  final Animation<double> animation;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DialChild({
    required this.animation,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: animation.value < 0.1,
          child: Opacity(
            opacity: animation.value,
            child: Padding(
              padding: EdgeInsets.only(top: 8 * (1 - animation.value)),
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: label,
              onPressed: onTap,
              backgroundColor: theme.colorScheme.secondaryContainer,
              foregroundColor: theme.colorScheme.onSecondaryContainer,
              child: Icon(icon),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 通用底部弹窗 ───

Future<T?> _showUnifiedBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Widget Function(T item) itemBuilder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(ctx).textTheme.titleLarge),
          ),
          ...items.map(itemBuilder),
        ],
      ),
    ),
  );
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

    return FloatingActionButton(
      onPressed: () => _showFilterSheet(context),
      tooltip: selectedCourse != null ? selectedCourse.name : '筛选课程',
      backgroundColor: isFiltered
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHigh,
      foregroundColor: isFiltered
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
      child: Icon(isFiltered ? Icons.filter_list : Icons.filter_list_outlined),
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
  final Map<String, List<CalendarDotColor>> dotStatesByDate;
  final ValueChanged<DateTime> onDateSelected;

  static const _weekdays = ['一', '二', '三', '四', '五', '六', '日'];

  const _WeekStrip({
    required this.weekStart,
    required this.selectedDate,
    required this.today,
    required this.dotStatesByDate,
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
          final dotStates = dotStatesByDate[dateStr];

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
                    if (dotStates != null && dotStates.isNotEmpty)
                      isSelected
                          ? _buildSelectedIndicator(theme, dotStates)
                          : _buildDots(theme, dotStates),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDots(ThemeData theme, List<CalendarDotColor> states) {
    final display = states.length > 4 ? states.sublist(0, 4) : states;
    final extra = states.length > 4 ? states.length - 4 : 0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 2,
      runSpacing: 1,
      children: [
        ...display.map(
          (s) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _dotColor(s),
              shape: BoxShape.circle,
            ),
          ),
        ),
        if (extra > 0)
          Text(
            '+$extra',
            style: TextStyle(
              fontSize: 8,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedIndicator(
    ThemeData theme,
    List<CalendarDotColor> states,
  ) {
    final mostUrgent = _mostUrgent(states);
    return Container(
      width: 16,
      height: 2,
      decoration: BoxDecoration(
        color: _dotColor(mostUrgent),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  static CalendarDotColor _mostUrgent(List<CalendarDotColor> states) {
    if (states.contains(CalendarDotColor.pastPending)) {
      return CalendarDotColor.pastPending;
    }
    if (states.contains(CalendarDotColor.upcoming)) {
      return CalendarDotColor.upcoming;
    }
    return CalendarDotColor.recorded;
  }

  static Color _dotColor(CalendarDotColor state) => switch (state) {
    CalendarDotColor.pastPending => Colors.red.shade400,
    CalendarDotColor.upcoming => Colors.orange.shade400,
    CalendarDotColor.recorded => Colors.green.shade500,
  };
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
  final DateTime now;

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
    required this.now,
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
                left: BorderSide(color: _indicatorColor(item), width: 3),
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

  Color _indicatorColor(HomeDayItem item) {
    final state = item.calendarDotState(now);
    return switch (state) {
      CalendarDotColor.pastPending => Colors.red.shade400,
      CalendarDotColor.upcoming => Colors.orange.shade400,
      CalendarDotColor.recorded => Colors.green.shade500,
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
  final Map<String, List<CalendarDotColor>> dotStatesByDate;
  final ValueChanged<DateTime> onDaySelected;

  const _MonthCalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.today,
    required this.dotStatesByDate,
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
              final dotStates = dotStatesByDate[dateStr];

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
                        if (dotStates != null && dotStates.isNotEmpty)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 1.5,
                            runSpacing: 1,
                            children: dotStates.map((state) {
                              return Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _selectedDotColor(state)
                                      : isCurrentMonth
                                      ? _dotColor(state)
                                      : _dotColor(state).withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
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

  static Color _dotColor(CalendarDotColor state) => switch (state) {
    CalendarDotColor.pastPending => Colors.red.shade400,
    CalendarDotColor.upcoming => Colors.orange.shade400,
    CalendarDotColor.recorded => Colors.green.shade500,
  };

  static Color _selectedDotColor(CalendarDotColor state) => switch (state) {
    CalendarDotColor.pastPending => Colors.red.shade200,
    CalendarDotColor.upcoming => Colors.orange.shade200,
    CalendarDotColor.recorded => Colors.green.shade300,
  };
}

// ─── 日历图例 ───

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const items = [
      (CalendarDotColor.pastPending, '待补录'),
      (CalendarDotColor.upcoming, '待上课'),
      (CalendarDotColor.recorded, '已记录'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.map((item) {
          final (state, label) = item;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _dotColor(state),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  static Color _dotColor(CalendarDotColor state) => switch (state) {
    CalendarDotColor.pastPending => Colors.red.shade400,
    CalendarDotColor.upcoming => Colors.orange.shade400,
    CalendarDotColor.recorded => Colors.green.shade500,
  };
}
