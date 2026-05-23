import 'package:drift/drift.dart';

// === 孩子 ===

class Children extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get avatarPath => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get gender => text().nullable().withLength(min: 1, max: 10)();
  TextColumn get notes => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 孩子课程 ===

class KidCourses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Children, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text().nullable().withLength(min: 1, max: 50)();
  TextColumn get categoryNameSnapshot => text().nullable()();
  TextColumn get institutionName =>
      text().nullable().withLength(min: 1, max: 100)();
  TextColumn get location => text().nullable()();
  IntColumn get defaultCreditUnitsCost => integer().nullable()();
  IntColumn get defaultDurationMinutes => integer().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 上课计划 ===

class CourseSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  // weekly_repeat | daily_repeat | single | date_list
  TextColumn get scheduleType => text().withLength(min: 1, max: 30)();
  TextColumn get classType => text().nullable()();
  TextColumn get classNameSnapshot => text().nullable()();
  IntColumn get weekday => integer().nullable()();
  TextColumn get date => text().nullable()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get dateList => text().nullable()();
  TextColumn get slotsJson => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get validFrom => dateTime()();
  DateTimeColumn get validUntil => dateTime().nullable()();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 课包 ===

class Packages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  // lesson_pack | trial_pack | gift_pack | period_pack
  TextColumn get type => text().withLength(min: 1, max: 30)();
  IntColumn get totalCredits => integer().nullable()();
  IntColumn get amountCents => integer().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  DateTimeColumn get validFrom => dateTime().nullable()();
  DateTimeColumn get validUntil => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isVoided => boolean().withDefault(const Constant(false))();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 上课记录 ===

class ClassRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  IntColumn get scheduleId =>
      integer().nullable().references(CourseSchedules, #id)();
  // attended | leave | cancelled | absent | makeup
  TextColumn get status => text().withLength(min: 1, max: 20)();
  TextColumn get classType => text().nullable()();
  TextColumn get classNameSnapshot => text().nullable()();
  TextColumn get classDate => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text().nullable()();
  IntColumn get durationMinutes => integer().nullable()();
  IntColumn get creditUnitsCost => integer().withDefault(const Constant(0))();
  IntColumn get packageId => integer().nullable().references(Packages, #id)();
  TextColumn get scheduleOccurrenceKey => text().nullable()();
  TextColumn get scheduleOccurrenceDate => text().nullable()();
  TextColumn get scheduleOccurrenceStartTime => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {scheduleId, scheduleOccurrenceKey},
  ];
}

// === 课时变化流水 ===

class CreditTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  IntColumn get packageId => integer().nullable().references(Packages, #id)();
  IntColumn get classRecordId =>
      integer().nullable().references(ClassRecords, #id)();
  // purchase | consume | adjust | refund | void | pending
  TextColumn get type => text().withLength(min: 1, max: 20)();
  IntColumn get creditUnitsDelta => integer()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

// === 费用记录 ===

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  IntColumn get packageId => integer().nullable().references(Packages, #id)();
  IntColumn get achievementId =>
      integer().nullable().references(Achievements, #id)();
  TextColumn get type => text().nullable()();
  TextColumn get typeNameSnapshot => text().nullable()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 成长记录 ===

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get childId => integer().references(Children, #id)();
  IntColumn get kidCourseId =>
      integer().nullable().references(KidCourses, #id)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get type => text().nullable()();
  TextColumn get typeNameSnapshot => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get achievementDate => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 成长记录类型关联 ===

class AchievementTypeLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get achievementId => integer().references(Achievements, #id)();
  TextColumn get type => text().withLength(min: 1, max: 50)();
  TextColumn get typeNameSnapshot => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {achievementId, type},
  ];
}

// === 附件 ===

class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  // class_record | achievement | package | payment | course
  TextColumn get ownerType => text().withLength(min: 1, max: 30)();
  IntColumn get ownerId => integer()();
  // photo | screenshot | contract | certificate | other
  TextColumn get fileType => text().withLength(min: 1, max: 20)();
  TextColumn get originalFileName => text().nullable()();
  TextColumn get relativePath => text()();
  IntColumn get fileSizeBytes => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// === 联系人 ===

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get kidCourseId => integer().references(KidCourses, #id)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  // teacher | coach | advisor | other
  TextColumn get role => text().nullable()();
  TextColumn get roleNameSnapshot => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get wechat => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// === 标签字典 ===

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withLength(min: 1, max: 50)();
  TextColumn get code => text().withLength(min: 1, max: 50)();
  TextColumn get displayName => text().withLength(min: 1, max: 50)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {category, code},
  ];
}

// === 用户反馈 ===

class FeedbackEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get contact => text().nullable()();
  TextColumn get status => text().withLength(min: 1, max: 20)();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get appName => text()();
  TextColumn get appVersion => text()();
  TextColumn get platform => text()();
  TextColumn get deviceInfo => text()();
  TextColumn get deviceId => text().nullable()();
  DateTimeColumn get submittedAt => dateTime()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
