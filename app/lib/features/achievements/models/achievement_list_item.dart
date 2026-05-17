import 'package:class2data/data/database/app_database.dart';

class AchievementListItem {
  final Achievement achievement;
  final List<AchievementTypeLink> typeLinks;
  final Payment? payment;

  const AchievementListItem({
    required this.achievement,
    required this.typeLinks,
    this.payment,
  });
}
