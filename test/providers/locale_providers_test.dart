import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/providers/locale_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<StorageService> newStorage() => StorageService.create();

  group('Language preference persistence', () {
    test('defaults to French when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      expect(await storage.getLocale(), const Locale('fr'));
    });

    test('the chosen language is read back', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      await storage.saveLocale(const Locale('en'));

      expect(await storage.getLocale(), const Locale('en'));
    });

    test('the stored value survives a restart', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final first = await newStorage();
      await first.saveLocale(const Locale('en'));

      // A second call emulates a new app start reading the same store.
      final second = await newStorage();
      expect(await second.getLocale(), const Locale('en'));
    });

    test('a damaged value falls back to French', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'app_locale': 'not-a-language',
      });
      final storage = await newStorage();

      expect(await storage.getLocale(), const Locale('fr'));
    });

    test('both supported languages round trip', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      for (final locale in [const Locale('fr'), const Locale('en')]) {
        await storage.saveLocale(locale);
        expect(await storage.getLocale(), locale);
      }
    });
  });

  group('LocaleNotifier', () {
    test('defaults to French', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      final notifier = LocaleNotifier(() async => storage);

      // Let the asynchronous load settle before asserting and disposing.
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, const Locale('fr'));
      notifier.dispose();
    });

    test('loads the stored preference', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      await storage.saveLocale(const Locale('en'));
      final notifier = LocaleNotifier(() async => storage);

      // The initial load is asynchronous: wait for the value to arrive.
      await notifier.stream.firstWhere(
        (locale) => locale.languageCode == 'en',
      );

      expect(notifier.state, const Locale('en'));
      notifier.dispose();
    });

    test('applies and persists a new preference', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      final notifier = LocaleNotifier(() async => storage);

      await notifier.setLocale(const Locale('en'));

      expect(notifier.state, const Locale('en'));
      expect(await storage.getLocale(), const Locale('en'));
      notifier.dispose();
    });

    test('keeps working when the storage cannot be read', () async {
      final notifier = LocaleNotifier(
        () => Future<StorageService>.error(StateError('no storage')),
      );

      // The choice still applies even when it cannot be persisted yet.
      await notifier.setLocale(const Locale('en'));
      expect(notifier.state, const Locale('en'));
      notifier.dispose();
    });
  });

  group('Locale provider', () {
    test('exposes the stored locale', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'app_locale': 'en',
      });
      final storage = await newStorage();

      final container = ProviderContainer(
        overrides: [
          storageServiceProvider.overrideWith((ref) async => storage),
        ],
      );
      addTearDown(container.dispose);

      // The notifier loads the stored value asynchronously.
      await container.read(localeProvider.notifier).stream.firstWhere(
            (locale) => locale.languageCode == 'en',
          );

      expect(container.read(localeProvider), const Locale('en'));
    });
  });
}
