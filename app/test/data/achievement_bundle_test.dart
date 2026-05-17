import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/data/database/daos/achievement_dao.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AchievementDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = AchievementDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('saveAchievementBundle writes type links and linked payment', () async {
    final now = DateTime(2026, 5, 17);
    final childId = await db
        .into(db.children)
        .insert(
          ChildrenCompanion.insert(name: '安安', createdAt: now, updatedAt: now),
        );
    final courseId = await db
        .into(db.kidCourses)
        .insert(
          KidCoursesCompanion.insert(
            childId: childId,
            name: '篮球',
            createdAt: now,
            updatedAt: now,
          ),
        );

    final achievementId = await dao.saveAchievementBundle(
      achievement: AchievementsCompanion(
        childId: Value(childId),
        kidCourseId: Value(courseId),
        title: const Value('篮球比赛二等奖'),
        type: const Value('competition_activity'),
        typeNameSnapshot: const Value('比赛/活动'),
        achievementDate: const Value('2026-05-17'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      typeLinks: [
        AchievementTypeLinksCompanion(
          type: const Value('competition_activity'),
          typeNameSnapshot: const Value('比赛/活动'),
          sortOrder: const Value(0),
          createdAt: Value(now),
        ),
        AchievementTypeLinksCompanion(
          type: const Value('award'),
          typeNameSnapshot: const Value('获奖'),
          sortOrder: const Value(1),
          createdAt: Value(now),
        ),
      ],
      payment: PaymentsCompanion(
        kidCourseId: Value(courseId),
        type: const Value('competition'),
        typeNameSnapshot: const Value('比赛费'),
        amountCents: const Value(12000),
        paymentDate: Value(now),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    final links = await dao.getTypeLinks(achievementId);
    final payment = await dao.getPaymentByAchievementId(achievementId);

    expect(links.map((link) => link.type), ['competition_activity', 'award']);
    expect(payment?.achievementId, achievementId);
    expect(payment?.amountCents, 12000);

    await dao.saveAchievementBundle(
      achievement: AchievementsCompanion(
        id: Value(achievementId),
        childId: Value(childId),
        kidCourseId: Value(courseId),
        title: const Value('篮球比赛二等奖'),
        type: const Value('award'),
        typeNameSnapshot: const Value('获奖'),
        achievementDate: const Value('2026-05-17'),
        updatedAt: Value(now),
      ),
      typeLinks: [
        AchievementTypeLinksCompanion(
          type: const Value('award'),
          typeNameSnapshot: const Value('获奖'),
          sortOrder: const Value(0),
          createdAt: Value(now),
        ),
      ],
    );

    final updatedLinks = await dao.getTypeLinks(achievementId);
    final deletedPayment = await dao.getPaymentByAchievementId(achievementId);

    expect(updatedLinks.single.type, 'award');
    expect(deletedPayment, isNull);
  });
}
