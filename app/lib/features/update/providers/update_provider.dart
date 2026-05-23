import 'package:class2data/features/update/services/update_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProvider = FutureProvider<UpdateInfo?>((ref) async {
  final service = UpdateService();
  return service.checkForUpdate();
});
