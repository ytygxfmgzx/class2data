import 'package:class2data/features/update/services/update_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateProvider = FutureProvider<UpdateInfo?>((ref) async {
  debugPrint('[updateProvider] 被触发，开始检查更新');
  final service = UpdateService();
  final result = await service.checkForUpdate();
  debugPrint('[updateProvider] 检查完成: ${result != null ? "有更新 v${result.version}, downloadUrl=${result.downloadUrl}" : "无更新"}');
  return result;
});
