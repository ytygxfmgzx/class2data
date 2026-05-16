import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/domain/models/schedule_slots.dart';

/// 计划课生成服务。
///
/// 从上课计划生成近期待处理课程，过滤已处理的记录。
class ScheduleOccurrenceService {
  /// 生成指定日期范围内的计划课实例。
  ///
  /// [schedules] — 所有活跃计划
  /// [existingRecords] — 已有的上课记录（用于去重）
  /// [startDate] / [endDate] — YYYY-MM-DD 格式
  List<ScheduleOccurrence> generateOccurrences({
    required List<CourseSchedule> schedules,
    required List<ClassRecord> existingRecords,
    required String startDate,
    required String endDate,
  }) {
    // 构建 scheduleId + occurrenceKey 的已处理集合
    final processedKeys = <String>{};
    for (final r in existingRecords) {
      if (r.scheduleId != null && r.scheduleOccurrenceKey != null) {
        processedKeys.add('${r.scheduleId}:${r.scheduleOccurrenceKey}');
      }
    }

    final results = <ScheduleOccurrence>[];

    for (final schedule in schedules) {
      final occurrences = _expandSchedule(schedule, startDate, endDate);
      for (final occ in occurrences) {
        final key = '${schedule.id}:${occ.occurrenceKey}';
        if (!processedKeys.contains(key)) {
          results.add(occ);
        }
      }
    }

    // 按日期和时间排序
    results.sort((a, b) {
      final dateCmp = a.date.compareTo(b.date);
      if (dateCmp != 0) return dateCmp;
      return a.startTime.compareTo(b.startTime);
    });

    return results;
  }

  List<ScheduleOccurrence> _expandSchedule(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    if (schedule.slotsJson != null && schedule.slotsJson!.isNotEmpty) {
      return _expandFromSlotsJson(schedule, startDate, endDate);
    }
    switch (schedule.scheduleType) {
      case 'weekly_repeat':
        return _expandWeekly(schedule, startDate, endDate);
      case 'daily_repeat':
        return _expandDaily(schedule, startDate, endDate);
      case 'single':
        return _expandSingle(schedule, startDate, endDate);
      case 'date_list':
        return _expandDateList(schedule, startDate, endDate);
      default:
        return [];
    }
  }

  List<ScheduleOccurrence> _expandFromSlotsJson(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    switch (schedule.scheduleType) {
      case 'weekly_repeat':
        return _expandWeeklySlots(schedule, startDate, endDate);
      case 'monthly_repeat':
        return _expandMonthlySlots(schedule, startDate, endDate);
      case 'date_list':
        return _expandDateListSlots(schedule, startDate, endDate);
      default:
        return [];
    }
  }

  List<ScheduleOccurrence> _expandWeeklySlots(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    final slots = ScheduleSlotsJson.decodeWeeklySlots(schedule.slotsJson!);
    if (slots.isEmpty) return [];

    final results = <ScheduleOccurrence>[];
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final validFrom = schedule.validFrom;
    final validUntil = schedule.validUntil;

    var current = DateTime(start.year, start.month, start.day);
    while (!current.isAfter(end)) {
      final dateStr = _formatDate(current);
      if (_isWithinValidity(dateStr, validFrom, validUntil)) {
        for (final slot in slots) {
          if (current.weekday == slot.weekday) {
            results.add(
              ScheduleOccurrence(
                scheduleId: schedule.id,
                kidCourseId: schedule.kidCourseId,
                date: dateStr,
                startTime: slot.startTime,
                endTime: slot.endTime,
                occurrenceKey: dateStr,
                classType: schedule.classType,
                classNameSnapshot: schedule.classNameSnapshot,
              ),
            );
          }
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return results;
  }

  List<ScheduleOccurrence> _expandMonthlySlots(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    final slots = ScheduleSlotsJson.decodeMonthlySlots(schedule.slotsJson!);
    if (slots.isEmpty) return [];

    final results = <ScheduleOccurrence>[];
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final validFrom = schedule.validFrom;
    final validUntil = schedule.validUntil;

    var current = DateTime(start.year, start.month, start.day);
    while (!current.isAfter(end)) {
      final dateStr = _formatDate(current);
      if (_isWithinValidity(dateStr, validFrom, validUntil)) {
        for (final slot in slots) {
          if (current.day == slot.dayOfMonth) {
            results.add(
              ScheduleOccurrence(
                scheduleId: schedule.id,
                kidCourseId: schedule.kidCourseId,
                date: dateStr,
                startTime: slot.startTime,
                endTime: slot.endTime,
                occurrenceKey: dateStr,
                classType: schedule.classType,
                classNameSnapshot: schedule.classNameSnapshot,
              ),
            );
          }
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return results;
  }

  List<ScheduleOccurrence> _expandDateListSlots(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    final slots = ScheduleSlotsJson.decodeDateSlots(schedule.slotsJson!);
    if (slots.isEmpty) return [];

    final results = <ScheduleOccurrence>[];
    for (final slot in slots) {
      if (slot.date.compareTo(startDate) < 0 ||
          slot.date.compareTo(endDate) > 0) {
        continue;
      }
      if (!_isWithinValidity(
        slot.date,
        schedule.validFrom,
        schedule.validUntil,
      )) {
        continue;
      }
      results.add(
        ScheduleOccurrence(
          scheduleId: schedule.id,
          kidCourseId: schedule.kidCourseId,
          date: slot.date,
          startTime: slot.startTime,
          endTime: slot.endTime,
          occurrenceKey: slot.date,
          classType: schedule.classType,
          classNameSnapshot: schedule.classNameSnapshot,
        ),
      );
    }

    return results;
  }

  List<ScheduleOccurrence> _expandWeekly(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    if (schedule.weekday == null) return [];

    final results = <ScheduleOccurrence>[];
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final validFrom = schedule.validFrom;
    final validUntil = schedule.validUntil;
    final targetWeekday = schedule.weekday!; // 1=Mon..7=Sun (ISO)

    var current = DateTime(start.year, start.month, start.day);
    while (!current.isAfter(end)) {
      // DateTime.weekday: 1=Mon..7=Sun (ISO)
      if (current.weekday == targetWeekday) {
        final dateStr = _formatDate(current);
        if (_isWithinValidity(dateStr, validFrom, validUntil)) {
          results.add(
            ScheduleOccurrence(
              scheduleId: schedule.id,
              kidCourseId: schedule.kidCourseId,
              date: dateStr,
              startTime: schedule.startTime,
              endTime: schedule.endTime,
              occurrenceKey: dateStr,
              classType: schedule.classType,
              classNameSnapshot: schedule.classNameSnapshot,
            ),
          );
        }
      }
      current = current.add(const Duration(days: 1));
    }

    return results;
  }

  List<ScheduleOccurrence> _expandDaily(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    final results = <ScheduleOccurrence>[];
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final validFrom = schedule.validFrom;
    final validUntil = schedule.validUntil;

    var current = DateTime(start.year, start.month, start.day);
    while (!current.isAfter(end)) {
      final dateStr = _formatDate(current);
      if (_isWithinValidity(dateStr, validFrom, validUntil)) {
        results.add(
          ScheduleOccurrence(
            scheduleId: schedule.id,
            kidCourseId: schedule.kidCourseId,
            date: dateStr,
            startTime: schedule.startTime,
            endTime: schedule.endTime,
            occurrenceKey: dateStr,
            classType: schedule.classType,
            classNameSnapshot: schedule.classNameSnapshot,
          ),
        );
      }
      current = current.add(const Duration(days: 1));
    }

    return results;
  }

  List<ScheduleOccurrence> _expandSingle(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    if (schedule.date == null) return [];

    final date = schedule.date!;
    if (date.compareTo(startDate) < 0 || date.compareTo(endDate) > 0) {
      return [];
    }

    return [
      ScheduleOccurrence(
        scheduleId: schedule.id,
        kidCourseId: schedule.kidCourseId,
        date: date,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        occurrenceKey: date,
        classType: schedule.classType,
        classNameSnapshot: schedule.classNameSnapshot,
      ),
    ];
  }

  List<ScheduleOccurrence> _expandDateList(
    CourseSchedule schedule,
    String startDate,
    String endDate,
  ) {
    if (schedule.dateList == null || schedule.dateList!.isEmpty) return [];

    final results = <ScheduleOccurrence>[];
    final dates = schedule.dateList!.split(',');

    for (final d in dates) {
      final trimmed = d.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.compareTo(startDate) < 0 || trimmed.compareTo(endDate) > 0) {
        continue;
      }
      results.add(
        ScheduleOccurrence(
          scheduleId: schedule.id,
          kidCourseId: schedule.kidCourseId,
          date: trimmed,
          startTime: schedule.startTime,
          endTime: schedule.endTime,
          occurrenceKey: trimmed,
          classType: schedule.classType,
          classNameSnapshot: schedule.classNameSnapshot,
        ),
      );
    }

    return results;
  }

  bool _isWithinValidity(
    String date,
    DateTime? validFrom,
    DateTime? validUntil,
  ) {
    final d = DateTime.parse(date);
    if (validFrom != null && d.isBefore(validFrom)) return false;
    if (validUntil != null && d.isAfter(validUntil)) return false;
    return true;
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

/// 计划课实例
class ScheduleOccurrence {
  final int scheduleId;
  final int kidCourseId;
  final String date; // YYYY-MM-DD
  final String startTime; // HH:mm
  final String endTime; // HH:mm
  final String occurrenceKey;
  final String? classType;
  final String? classNameSnapshot;

  const ScheduleOccurrence({
    required this.scheduleId,
    required this.kidCourseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.occurrenceKey,
    this.classType,
    this.classNameSnapshot,
  });
}
