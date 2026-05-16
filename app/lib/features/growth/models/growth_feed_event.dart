class GrowthFeedEvent {
  final DateTime sortDateTime;
  final String type;
  final int childId;
  final String childName;
  final String? childAvatarPath;
  final int? courseId;
  final String? courseName;
  final String title;
  final String? subtitle;
  final String? notes;
  final List<String> imagePaths;
  final int? recordId;
  final int? achievementId;
  final int? packageId;
  final String? recordStatus;
  final String? timeRange;

  const GrowthFeedEvent({
    required this.sortDateTime,
    required this.type,
    required this.childId,
    required this.childName,
    this.childAvatarPath,
    this.courseId,
    this.courseName,
    required this.title,
    this.subtitle,
    this.notes,
    this.imagePaths = const [],
    this.recordId,
    this.achievementId,
    this.packageId,
    this.recordStatus,
    this.timeRange,
  });

  String get dateKey =>
      '${sortDateTime.year.toString().padLeft(4, '0')}-'
      '${sortDateTime.month.toString().padLeft(2, '0')}-'
      '${sortDateTime.day.toString().padLeft(2, '0')}';
}

class GrowthFilter {
  final int? childId;
  final Set<String> types;
  final String? dateFrom; // YYYY-MM
  final String? dateTo; // YYYY-MM

  const GrowthFilter({
    this.childId,
    this.types = const {},
    this.dateFrom,
    this.dateTo,
  });

  bool get showAllChildren => childId == null;
  bool get showAllTypes => types.isEmpty;
  bool showsType(String type) => showAllTypes || types.contains(type);
  bool get showAllDates => dateFrom == null && dateTo == null;

  bool matchesDate(String dateKey) {
    final eventMonth = dateKey.substring(0, 7);
    if (dateFrom != null && eventMonth.compareTo(dateFrom!) < 0) return false;
    if (dateTo != null && eventMonth.compareTo(dateTo!) > 0) return false;
    return true;
  }
}
