import 'dart:io';

import 'package:flutter/material.dart';

class PhotoViewerDialog {
  static Future<void> show(
    BuildContext context, {
    required List<String> imagePaths,
    int initialIndex = 0,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _PhotoViewerContent(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _PhotoViewerContent extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _PhotoViewerContent({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_PhotoViewerContent> createState() => _PhotoViewerContentState();
}

class _PhotoViewerContentState extends State<_PhotoViewerContent> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.imagePaths.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Column(
          children: [
            // 顶栏：页码 + 关闭
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${_currentIndex + 1} / $total',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            // 照片
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: total,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(
                          File(widget.imagePaths[index]),
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.broken_image,
                            color: Colors.white38,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
