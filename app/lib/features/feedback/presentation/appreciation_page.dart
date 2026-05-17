import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AppreciationPage extends StatelessWidget {
  const AppreciationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('请开发者喝茶')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const _AppreciationIntro(),
            const SizedBox(height: 12),
            _QrcodeSection(onShare: () => _shareQrcode(context)),
            const SizedBox(height: 12),
            _SupportNotes(theme: theme),
          ],
        ),
      ),
    );
  }

  Future<void> _shareQrcode(BuildContext context) async {
    try {
      final byteData = await rootBundle.load(
        'assets/images/appreciation_qrcode.png',
      );
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/appreciation_qrcode.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      if (context.mounted) {
        await Share.shareXFiles([XFile(file.path)], text: '请开发者喝茶，感谢你的支持！');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('分享失败: $e')));
      }
    }
  }
}

class _AppreciationIntro extends StatelessWidget {
  const _AppreciationIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD591)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFD591)),
            ),
            child: const Icon(
              Icons.local_cafe_outlined,
              color: Color(0xFFAD6800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '谢谢你愿意支持这个 App',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF613400),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '如果它帮你省下一点整理课外班账目的时间，可以请开发者喝杯茶。每一份鼓励都会用在后续维护和体验打磨上。',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: const Color(0xFF8C5A13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrcodeSection extends StatelessWidget {
  final VoidCallback onShare;

  const _QrcodeSection({required this.onShare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '微信赞赏码',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '分享给微信好友再长按识别二维码~',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.qr_code_2, color: theme.colorScheme.primary, size: 28),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final qrSize = math.min(constraints.maxWidth - 48, 280.0);
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/appreciation_qrcode.png',
                      width: qrSize,
                      height: qrSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.ios_share, size: 18),
              label: const Text('分享赞赏码'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportNotes extends StatelessWidget {
  final ThemeData theme;

  const _SupportNotes({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '这不是必须项，但来都来了~💐💐💐',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
