import 'dart:io';

import 'package:class2data/features/growth/providers/photo_wall_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoWallPage extends ConsumerWidget {
  final int childId;

  const PhotoWallPage({super.key, required this.childId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(childPhotosProvider(childId));

    return Scaffold(
      appBar: AppBar(title: const Text('照片墙')),
      body: photosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (photos) {
          if (photos.isEmpty) {
            return const Center(child: Text('还没有照片'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return _PhotoTile(photo: photos[index]);
            },
          );
        },
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final PhotoEntry photo;

  const _PhotoTile({required this.photo});

  @override
  Widget build(BuildContext context) {
    final path = photo.absolutePath;

    if (path == null || !File(path).existsSync()) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: Icon(Icons.broken_image, size: 32)),
      );
    }

    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(child: Icon(Icons.broken_image, size: 32)),
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    final path = photo.absolutePath;
    if (path == null || !File(path).existsSync()) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullImagePage(path: path, label: photo.ownerLabel),
      ),
    );
  }
}

class _FullImagePage extends StatelessWidget {
  final String path;
  final String label;

  const _FullImagePage({required this.path, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: InteractiveViewer(child: Image.file(File(path)))),
    );
  }
}
