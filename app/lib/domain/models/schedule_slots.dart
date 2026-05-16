import 'dart:convert';

/// 周循环的时间槽
class WeekdaySlot {
  final int weekday; // 1=周一, 7=周日
  final String startTime; // HH:mm
  final String endTime; // HH:mm

  const WeekdaySlot({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'weekday': weekday,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory WeekdaySlot.fromJson(Map<String, dynamic> json) => WeekdaySlot(
    weekday: json['weekday'] as int,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
  );
}

/// 月循环的时间槽
class MonthDaySlot {
  final int dayOfMonth; // 1-31
  final String startTime;
  final String endTime;

  const MonthDaySlot({
    required this.dayOfMonth,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'dayOfMonth': dayOfMonth,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory MonthDaySlot.fromJson(Map<String, dynamic> json) => MonthDaySlot(
    dayOfMonth: json['dayOfMonth'] as int,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
  );
}

/// 指定日期的时间槽
class DateSlot {
  final String date; // YYYY-MM-DD
  final String startTime;
  final String endTime;

  const DateSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory DateSlot.fromJson(Map<String, dynamic> json) => DateSlot(
    date: json['date'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
  );
}

/// slotsJson 的序列化工具
class ScheduleSlotsJson {
  ScheduleSlotsJson._();

  static String encodeWeeklySlots(List<WeekdaySlot> slots) {
    return jsonEncode(slots.map((s) => s.toJson()).toList());
  }

  static List<WeekdaySlot> decodeWeeklySlots(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => WeekdaySlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String encodeMonthlySlots(List<MonthDaySlot> slots) {
    return jsonEncode(slots.map((s) => s.toJson()).toList());
  }

  static List<MonthDaySlot> decodeMonthlySlots(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => MonthDaySlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String encodeDateSlots(List<DateSlot> slots) {
    return jsonEncode(slots.map((s) => s.toJson()).toList());
  }

  static List<DateSlot> decodeDateSlots(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((e) => DateSlot.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
