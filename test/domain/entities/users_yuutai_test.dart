import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart';

void main() {
  group('UsersYuutai', () {
    group('fromJson', () {
      test('should deserialize valid JSON correctly', () {
        // Arrange
        final json = {
          'id': 'test-id-123',
          'title': 'Test Company',
          'brandId': 'brand-123',
          'companyId': 'company-123',
          'benefitText': '3000円分の商品券',
          'notes': 'Test notes',
          'notifyBeforeDays': 7,
          'notifyAtHour': 9,
          'expireOn': '2025-12-31T00:00:00.000Z',
          'isUsed': false,
          'tags': ['food', 'restaurant'],
        };

        // Act
        final result = UsersYuutai.fromJson(json);

        // Assert
        expect(result.id, 'test-id-123');
        expect(result.title, 'Test Company');
        expect(result.brandId, 'brand-123');
        expect(result.companyId, 'company-123');
        expect(result.benefitText, '3000円分の商品券');
        expect(result.notes, 'Test notes');
        expect(result.notifyBeforeDays, 7);
        expect(result.notifyAtHour, 9);
        expect(result.expireOn, DateTime.parse('2025-12-31T00:00:00.000Z'));
        expect(result.isUsed, false);
        expect(result.tags, ['food', 'restaurant']);
      });

      test('should handle minimal required fields only', () {
        // Arrange
        final json = {'id': 'min-id', 'title': 'Minimal'};

        // Act
        final result = UsersYuutai.fromJson(json);

        // Assert
        expect(result.id, 'min-id');
        expect(result.title, 'Minimal');
        expect(result.brandId, null);
        expect(result.companyId, null);
        expect(result.benefitText, null);
        expect(result.notes, null);
        expect(result.notifyBeforeDays, null);
        expect(result.notifyAtHour, null);
        expect(result.expireOn, null);
        expect(result.isUsed, false);
        expect(result.tags, []);
      });

      test('should handle null optional fields correctly', () {
        // Arrange
        final json = {
          'id': 'test-id',
          'title': 'Test',
          'brandId': null,
          'benefitText': null,
          'expireOn': null,
        };

        // Act
        final result = UsersYuutai.fromJson(json);

        // Assert
        expect(result.brandId, null);
        expect(result.benefitText, null);
        expect(result.expireOn, null);
      });
    });

    group('toJson', () {
      test('should serialize to JSON correctly with all fields', () {
        // Arrange
        final expireDate = DateTime.parse('2025-12-31T00:00:00.000Z');
        final benefit = UsersYuutai(
          id: 'test-id-123',
          title: 'Test Company',
          brandId: 'brand-123',
          companyId: 'company-123',
          benefitText: '3000円分の商品券',
          notes: 'Test notes',
          notifyBeforeDays: 7,
          notifyAtHour: 9,
          expireOn: expireDate,
          isUsed: false,
          tags: ['food', 'restaurant'],
        );

        // Act
        final json = benefit.toJson();

        // Assert
        expect(json['id'], 'test-id-123');
        expect(json['title'], 'Test Company');
        expect(json['brandId'], 'brand-123');
        expect(json['companyId'], 'company-123');
        expect(json['benefitText'], '3000円分の商品券');
        expect(json['notes'], 'Test notes');
        expect(json['notifyBeforeDays'], 7);
        expect(json['notifyAtHour'], 9);
        expect(json['expireOn'], expireDate.toIso8601String());
        expect(json['isUsed'], false);
        expect(json['tags'], ['food', 'restaurant']);
      });

      test('should serialize minimal fields correctly', () {
        // Arrange
        final benefit = const UsersYuutai(id: 'min-id', title: 'Minimal');

        // Act
        final json = benefit.toJson();

        // Assert
        expect(json['id'], 'min-id');
        expect(json['title'], 'Minimal');
        expect(json['isUsed'], false);
        expect(json['tags'], []);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        // Arrange
        final original = const UsersYuutai(
          id: 'test-id',
          title: 'Original Title',
          benefitText: 'Original benefit',
          isUsed: false,
        );

        // Act
        final updated = original.copyWith(title: 'Updated Title', isUsed: true);

        // Assert
        expect(updated.id, 'test-id');
        expect(updated.title, 'Updated Title');
        expect(updated.benefitText, 'Original benefit');
        expect(updated.isUsed, true);
        expect(original.isUsed, false); // Original unchanged
      });

      test('should allow setting fields to null', () {
        // Arrange
        final original = const UsersYuutai(
          id: 'test-id',
          title: 'Title',
          benefitText: 'Some benefit',
          notifyBeforeDays: 7,
        );

        // Act
        final updated = original.copyWith(
          benefitText: null,
          notifyBeforeDays: null,
        );

        // Assert
        expect(updated.benefitText, null);
        expect(updated.notifyBeforeDays, null);
      });
    });

    group('equality', () {
      test('should be equal for identical values', () {
        // Arrange
        final benefit1 = const UsersYuutai(
          id: 'test-id',
          title: 'Test',
          benefitText: 'Benefit',
          isUsed: false,
        );
        final benefit2 = const UsersYuutai(
          id: 'test-id',
          title: 'Test',
          benefitText: 'Benefit',
          isUsed: false,
        );

        // Assert
        expect(benefit1, equals(benefit2));
        expect(benefit1.hashCode, equals(benefit2.hashCode));
      });

      test('should not be equal for different values', () {
        // Arrange
        final benefit1 = const UsersYuutai(id: 'test-id-1', title: 'Test');
        final benefit2 = const UsersYuutai(id: 'test-id-2', title: 'Test');

        // Assert
        expect(benefit1, isNot(equals(benefit2)));
      });
    });

    group('business logic validation', () {
      test('should handle past expiry dates', () {
        // Arrange
        final pastDate = DateTime.now().subtract(const Duration(days: 1));
        final benefit = UsersYuutai(
          id: 'test-id',
          title: 'Expired Benefit',
          expireOn: pastDate,
        );

        // Assert
        expect(benefit.expireOn, isNotNull);
        expect(benefit.expireOn!.isBefore(DateTime.now()), true);
      });

      test('should handle future expiry dates', () {
        // Arrange
        final futureDate = DateTime.now().add(const Duration(days: 30));
        final benefit = UsersYuutai(
          id: 'test-id',
          title: 'Future Benefit',
          expireOn: futureDate,
        );

        // Assert
        expect(benefit.expireOn, isNotNull);
        expect(benefit.expireOn!.isAfter(DateTime.now()), true);
      });

      test('should accept valid notifyAtHour range (0-23)', () {
        // Test boundary values
        final benefit0 = const UsersYuutai(
          id: 'test-id',
          title: 'Test',
          notifyAtHour: 0,
        );
        final benefit23 = const UsersYuutai(
          id: 'test-id',
          title: 'Test',
          notifyAtHour: 23,
        );

        expect(benefit0.notifyAtHour, 0);
        expect(benefit23.notifyAtHour, 23);
      });

      test('should accept valid notifyBeforeDays', () {
        // Test common notification periods
        final presets = [1, 3, 7, 30];

        for (final days in presets) {
          final benefit = UsersYuutai(
            id: 'test-id',
            title: 'Test',
            notifyBeforeDays: days,
          );
          expect(benefit.notifyBeforeDays, days);
        }
      });
    });
  });
}
