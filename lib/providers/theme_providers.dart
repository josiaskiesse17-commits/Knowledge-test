import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/services/storage_service.dart';

/// Loads the local storage used to keep the theme preference.
typedef StorageLoader = Future<StorageService> Function();

/// User theme preference: light, dark or follow the system.
///
/// The value is loaded from local storage on start and every change is written
/// back, so the choice survives an app restart without any account.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._storageLoader) : super(ThemeMode.system) {
    _load();
  }

  final StorageLoader _storageLoader;

  /// Set as soon as the user picks a theme, so the load that is still running
  /// when the app starts never overrides that choice.
  bool _userChoice = false;

  Future<void> _load() async {
    ThemeMode stored;
    try {
      final storage = await _storageLoader();
      stored = await storage.getThemeMode();
    } catch (_) {
      // Without storage the system theme is used.
      stored = ThemeMode.system;
    }
    if (_userChoice) return;
    state = stored;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _userChoice = true;
    state = mode;
    try {
      final storage = await _storageLoader();
      await storage.saveThemeMode(mode);
    } catch (_) {
      // The choice is applied even when it cannot be persisted yet.
    }
  }

  /// Cycles light -> dark -> system -> light.
  Future<void> toggle() async {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(next);
  }
}

/// Current theme mode of the app, persisted locally.
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(() => ref.read(storageServiceProvider.future));
});
