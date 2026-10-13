import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<StorageService> newStorage() => StorageService.create();

  group('Theme preference persistence', () {
    test('defaults to the system theme when nothing is stored', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      expect(await storage.getThemeMode(), ThemeMode.system);
    });

    test('the chosen theme is read back', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      await storage.saveThemeMode(ThemeMode.dark);

      expect(await storage.getThemeMode(), ThemeMode.dark);
    });

    test('the stored value survives a restart', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final first = await newStorage();
      await first.saveThemeMode(ThemeMode.light);

      // A second call emulates a new app start reading the same store.
      final second = await newStorage();
      expect(await second.getThemeMode(), ThemeMode.light);
    });

    test('a damaged value falls back to the system theme', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'not-a-theme',
      });
      final storage = await newStorage();

      expect(await storage.getThemeMode(), ThemeMode.system);
    });

    test('every theme mode round trips', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();

      for (final mode in ThemeMode.values) {
        await storage.saveThemeMode(mode);
        expect(await storage.getThemeMode(), mode);
      }
    });
  });

  group('ThemeModeNotifier', () {
    test('loads the stored preference', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      await storage.saveThemeMode(ThemeMode.dark);
      final notifier = ThemeModeNotifier(() async => storage);

      // The initial load is asynchronous: wait for the value to arrive.
      await notifier.stream.firstWhere((mode) => mode == ThemeMode.dark);

      expect(notifier.state, ThemeMode.dark);
      notifier.dispose();
    });

    test('applies and persists a new preference', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      final notifier = ThemeModeNotifier(() async => storage);

      await notifier.setThemeMode(ThemeMode.light);

      expect(notifier.state, ThemeMode.light);
      expect(await storage.getThemeMode(), ThemeMode.light);
      notifier.dispose();
    });

    test('cycles light, dark then system', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await newStorage();
      final notifier = ThemeModeNotifier(() async => storage);
      await notifier.setThemeMode(ThemeMode.light);

      await notifier.toggle();
      expect(notifier.state, ThemeMode.dark);

      await notifier.toggle();
      expect(notifier.state, ThemeMode.system);

      await notifier.toggle();
      expect(notifier.state, ThemeMode.light);
      notifier.dispose();
    });

    test('keeps working when the storage cannot be read', () async {
      final notifier = ThemeModeNotifier(
        () => Future<StorageService>.error(StateError('no storage')),
      );

      // The choice still applies even when it cannot be persisted.
      await notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.state, ThemeMode.dark);
      notifier.dispose();
    });
  });

  group('Theme provider', () {
    test('exposes the stored theme mode', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'dark',
      });
      final storage = await newStorage();

      final container = ProviderContainer(
        overrides: [storageServiceProvider.overrideWith((ref) async => storage)],
      );
      addTearDown(container.dispose);

      // The notifier loads the stored value asynchronously.
      await container.read(themeModeProvider.notifier).stream
          .firstWhere((mode) => mode == ThemeMode.dark);

      expect(container.read(themeModeProvider), ThemeMode.dark);
    });
  });
}
