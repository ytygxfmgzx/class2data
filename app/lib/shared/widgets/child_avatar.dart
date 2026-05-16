import 'dart:io';

import 'package:class2data/domain/services/avatar_file_service.dart';
import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final String name;
  final String? avatarPath;
  final double radius;

  const ChildAvatar({
    super.key,
    required this.name,
    this.avatarPath,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.isNotEmpty ? name[0] : '?';

    if (avatarPath != null && avatarPath!.isNotEmpty) {
      return FutureBuilder<String>(
        future: AvatarFileService.instance.getAbsolutePath(avatarPath!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final file = File(snapshot.data!);
            if (file.existsSync()) {
              return CircleAvatar(
                radius: radius,
                backgroundImage: FileImage(file),
              );
            }
          }
          return _buildInitialAvatar(theme, initial);
        },
      );
    }

    return _buildInitialAvatar(theme, initial);
  }

  Widget _buildInitialAvatar(ThemeData theme, String initial) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
