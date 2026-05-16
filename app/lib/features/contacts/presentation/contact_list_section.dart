import 'package:class2data/core/result/result.dart';
import 'package:class2data/data/database/app_database.dart';
import 'package:class2data/features/contacts/providers/contact_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactListSection extends ConsumerWidget {
  final int courseId;

  const ContactListSection({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsByCourseProvider(courseId));
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '联系人',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    context.push('/courses/$courseId/contacts/add'),
                child: const Text('添加'),
              ),
            ],
          ),
        ),
        contactsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('加载失败: $e'),
          ),
          data: (result) => switch (result) {
            Ok(:final value) =>
              value.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('暂无联系人'),
                    )
                  : Column(
                      children: value
                          .map(
                            (c) => _ContactRow(contact: c, courseId: courseId),
                          )
                          .toList(),
                    ),
            Err(:final error) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(error.message),
            ),
          },
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Contact contact;
  final int courseId;

  const _ContactRow({required this.contact, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () =>
          context.push('/courses/$courseId/contacts/${contact.id}/edit'),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(contact.name, style: theme.textTheme.bodyMedium),
                  if (contact.roleNameSnapshot != null)
                    Text(
                      contact.roleNameSnapshot!,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (contact.phone != null)
              Text(
                contact.phone!,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
