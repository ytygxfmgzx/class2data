import 'package:class2data/domain/services/credit_balance_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditBalanceService period package display', () {
    final service = CreditBalanceService();
    final validFrom = DateTime(2026, 5, 10);
    final validUntil = DateTime(2026, 5, 20);

    test('shows not started before valid date', () {
      expect(
        service.periodPackageStatusLabel(
          now: DateTime(2026, 5, 9, 23, 59),
          validFrom: validFrom,
          validUntil: validUntil,
        ),
        '未开始',
      );
    });

    test('shows active within valid date range including boundary days', () {
      expect(
        service.periodPackageStatusLabel(
          now: DateTime(2026, 5, 10),
          validFrom: validFrom,
          validUntil: validUntil,
        ),
        '进行中',
      );
      expect(
        service.periodPackageStatusLabel(
          now: DateTime(2026, 5, 20, 23, 59),
          validFrom: validFrom,
          validUntil: validUntil,
        ),
        '进行中',
      );
    });

    test('shows ended after valid date', () {
      expect(
        service.periodPackageStatusLabel(
          now: DateTime(2026, 5, 21),
          validFrom: validFrom,
          validUntil: validUntil,
        ),
        '已结束',
      );
    });

    test('formats validity dates after status', () {
      expect(
        service.periodPackageValidityLabel(validFrom, validUntil),
        '2026-05-10 至 2026-05-20',
      );
    });
  });
}
