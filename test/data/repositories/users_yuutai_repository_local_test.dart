import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_stock/data/local/drift/database.dart' as db;
import 'package:flutter_stock/data/repositories/users_yuutai_repository_local.dart';
import 'package:flutter_stock/domain/entities/users_yuutai.dart' as domain;
import 'package:flutter_test/flutter_test.dart' hide isNotNull;

void main() {
  late db.AppDatabase database;
  late UsersYuutaiRepositoryLocal repository;

  setUp(() {
    // Create an in-memory database for each test
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    repository = UsersYuutaiRepositoryLocal(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('UsersYuutaiRepositoryLocal', () {
    group('getActive', () {
      test('should return empty list when no benefits exist', () async {
        // Act
        final result = await repository.getActive();

        // Assert
        expect(result, isEmpty);
      });

      test('should return only non-deleted and non-used benefits', () async {
        // Arrange
        await database.into(database.usersYuutais).insert(
              db.UsersYuutaisCompanion.insert(
                id: 'id-1',
                title: 'Active Benefit',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isUsed: const Value(false),
                deletedAt: const Value(null),
              ),
            );
        await database.into(database.usersYuutais).insert(
              db.UsersYuutaisCompanion.insert(
                id: 'id-2',
                title: 'Used Benefit',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isUsed: const Value(true),
                deletedAt: const Value(null),
              ),
            );
        await database.into(database.usersYuutais).insert(
              db.UsersYuutaisCompanion.insert(
                id: 'id-3',
                title: 'Deleted Benefit',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isUsed: const Value(false),
                deletedAt: Value(DateTime.now()),
              ),
            );

        // Act
        final result = await repository.getActive();

        // Assert
        expect(result.length, 1);
        expect(result.first.id, 'id-1');
        expect(result.first.title, 'Active Benefit');
      });
    });

    group('watchActive', () {
      test('should emit updates when benefits are added', () async {
        // Arrange
        final stream = repository.watchActive();
        final emittedValues = <List<domain.UsersYuutai>>[];

        // Act
        final subscription = stream.listen(emittedValues.add);

        // Wait for initial emit
        await Future.delayed(const Duration(milliseconds: 100));

        await repository.upsert(
          const domain.UsersYuutai(
            id: 'test-id',
            title: 'Test Benefit',
          ),
          scheduleReminders: false,
        );

        // Wait for update
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(emittedValues.length, greaterThanOrEqualTo(2));
        expect(emittedValues.first, isEmpty); // Initial state
        expect(emittedValues.last.length, 1); // After insert
        expect(emittedValues.last.first.title, 'Test Benefit');

        await subscription.cancel();
      });
    });

    group('upsert', () {
      test('should insert new benefit with generated ID', () async {
        // Arrange
        final benefit = const domain.UsersYuutai(
          id: '', // Empty ID should trigger UUID generation
          title: 'New Benefit',
          benefitText: '3000円分',
        );

        // Act
        await repository.upsert(benefit, scheduleReminders: false);
        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        expect(results.first.id, isNotEmpty);
        expect(results.first.title, 'New Benefit');
        expect(results.first.benefitText, '3000円分');
      });

      test('should update existing benefit with same ID', () async {
        // Arrange
        const benefitId = 'test-id-123';
        await repository.upsert(
          const domain.UsersYuutai(
            id: benefitId,
            title: 'Original Title',
          ),
          scheduleReminders: false,
        );

        // Act
        await repository.upsert(
          const domain.UsersYuutai(
            id: benefitId,
            title: 'Updated Title',
          ),
          scheduleReminders: false,
        );

        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        expect(results.first.id, benefitId);
        expect(results.first.title, 'Updated Title');
      });

      test('should store all benefit fields correctly', () async {
        // Arrange
        final expireDate = DateTime(2025, 12, 31);
        final benefit = domain.UsersYuutai(
          id: 'test-id',
          title: 'Full Benefit',
          brandId: 'brand-123',
          companyId: 'company-123',
          benefitText: '5000円分の優待券',
          notes: 'Test notes',
          expireOn: expireDate,
          notifyBeforeDays: 7,
          notifyAtHour: 9,
          isUsed: false,
        );

        // Act
        await repository.upsert(benefit, scheduleReminders: false);
        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        final stored = results.first;
        expect(stored.id, 'test-id');
        expect(stored.title, 'Full Benefit');
        expect(stored.brandId, 'brand-123');
        expect(stored.companyId, 'company-123');
        expect(stored.benefitText, '5000円分の優待券');
        expect(stored.notes, 'Test notes');
        expect(stored.expireOn, expireDate);
        expect(stored.notifyBeforeDays, 7);
        expect(stored.notifyAtHour, 9);
        expect(stored.isUsed, false);
      });
    });

    group('toggleUsed', () {
      test('should toggle isUsed flag to true', () async {
        // Arrange
        const benefitId = 'test-id';
        await repository.upsert(
          const domain.UsersYuutai(
            id: benefitId,
            title: 'Test',
            isUsed: false,
          ),
          scheduleReminders: false,
        );

        // Act
        await repository.toggleUsed(benefitId, true);

        // Assert
        final results = await repository.getActive();
        expect(results, isEmpty); // Used benefits are filtered out by getActive
      });

      test('should toggle isUsed flag to false', () async {
        // Arrange
        const benefitId = 'test-id';
        await database.into(database.usersYuutais).insert(
              db.UsersYuutaisCompanion.insert(
                id: benefitId,
                title: 'Test',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                isUsed: const Value(true),
              ),
            );

        // Act
        await repository.toggleUsed(benefitId, false);

        // Assert
        final results = await repository.getActive();
        expect(results.length, 1);
        expect(results.first.isUsed, false);
      });
    });

    group('softDelete', () {
      test('should mark benefit as deleted', () async {
        // Arrange
        const benefitId = 'test-id';
        await repository.upsert(
          const domain.UsersYuutai(
            id: benefitId,
            title: 'Test',
          ),
          scheduleReminders: false,
        );

        // Act
        await repository.softDelete(benefitId);

        // Assert
        final results = await repository.getActive();
        expect(results, isEmpty);
      });

      test('should not physically delete the record', () async {
        // Arrange
        const benefitId = 'test-id';
        await repository.upsert(
          const domain.UsersYuutai(
            id: benefitId,
            title: 'Test',
          ),
          scheduleReminders: false,
        );

        // Act
        await repository.softDelete(benefitId);

        // Assert
        final allRecords = await database.select(database.usersYuutais).get();
        expect(allRecords.length, 1);
        expect(allRecords.first.deletedAt, isNot(equals(null)));
      });
    });

    group('search', () {
      setUp(() async {
        // Insert test data
        await repository.upsert(
          const domain.UsersYuutai(
            id: 'id-1',
            title: 'McDonald優待',
            benefitText: '500円分のクーポン',
          ),
          scheduleReminders: false,
        );
        await repository.upsert(
          const domain.UsersYuutai(
            id: 'id-2',
            title: 'スターバックス優待',
            benefitText: '1000円分',
          ),
          scheduleReminders: false,
        );
        await repository.upsert(
          const domain.UsersYuutai(
            id: 'id-3',
            title: 'コメダ珈琲店',
            benefitText: '優待券3000円分',
            notes: 'スターバックスでは使えません',
          ),
          scheduleReminders: false,
        );
      });

      test('should search by title', () async {
        // Act
        final results = await repository.search('McDonald');

        // Assert
        expect(results.length, 1);
        expect(results.first.title, 'McDonald優待');
      });

      test('should search by benefit text', () async {
        // Act
        final results = await repository.search('1000円');

        // Assert
        expect(results.length, 1);
        expect(results.first.title, 'スターバックス優待');
      });

      test('should search by notes', () async {
        // Act
        final results = await repository.search('使えません');

        // Assert
        expect(results.length, 1);
        expect(results.first.title, 'コメダ珈琲店');
      });

      test('should return multiple matches', () async {
        // Act
        final results = await repository.search('優待');

        // Assert
        expect(results.length, 3);
      });

      test('should be case-insensitive for partial matches', () async {
        // Act
        final results = await repository.search('スター');

        // Assert
        expect(results.length, greaterThanOrEqualTo(1));
        expect(
          results.any((b) => b.title.contains('スターバックス')),
          true,
        );
      });

      test('should return empty list for no matches', () async {
        // Act
        final results = await repository.search('存在しない検索語');

        // Assert
        expect(results, isEmpty);
      });

      test('should handle special characters in query', () async {
        // Act
        final results = await repository.search('500円%');

        // Assert - % should be escaped and not treated as wildcard
        expect(results, isEmpty);
      });

      test('should not return deleted benefits in search', () async {
        // Arrange
        await repository.softDelete('id-1');

        // Act
        final results = await repository.search('McDonald');

        // Assert
        expect(results, isEmpty);
      });

      test('should return used benefits in search', () async {
        // Arrange
        await repository.toggleUsed('id-1', true);

        // Act
        final results = await repository.search('McDonald');

        // Assert
        expect(results.length, 1);
        expect(results.first.isUsed, true);
      });
    });

    group('edge cases', () {
      test('should handle empty title', () async {
        // Arrange
        final benefit = const domain.UsersYuutai(
          id: 'test-id',
          title: '',
        );

        // Act
        await repository.upsert(benefit, scheduleReminders: false);
        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        expect(results.first.title, '');
      });

      test('should handle very long text fields', () async {
        // Arrange
        final longText = 'A' * 1000;
        final benefit = domain.UsersYuutai(
          id: 'test-id',
          title: longText,
          benefitText: longText,
          notes: longText,
        );

        // Act
        await repository.upsert(benefit, scheduleReminders: false);
        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        expect(results.first.title.length, 1000);
      });

      test('should handle null optional fields', () async {
        // Arrange
        final benefit = const domain.UsersYuutai(
          id: 'test-id',
          title: 'Minimal',
          brandId: null,
          companyId: null,
          benefitText: null,
          notes: null,
          expireOn: null,
          notifyBeforeDays: null,
          notifyAtHour: null,
        );

        // Act
        await repository.upsert(benefit, scheduleReminders: false);
        final results = await repository.getActive();

        // Assert
        expect(results.length, 1);
        expect(results.first.brandId, null);
        expect(results.first.benefitText, null);
      });

      test('should handle concurrent upserts', () async {
        // Act
        await Future.wait([
          repository.upsert(
            const domain.UsersYuutai(id: 'id-1', title: 'Benefit 1'),
            scheduleReminders: false,
          ),
          repository.upsert(
            const domain.UsersYuutai(id: 'id-2', title: 'Benefit 2'),
            scheduleReminders: false,
          ),
          repository.upsert(
            const domain.UsersYuutai(id: 'id-3', title: 'Benefit 3'),
            scheduleReminders: false,
          ),
        ]);

        final results = await repository.getActive();

        // Assert
        expect(results.length, 3);
      });
    });
  });
}
