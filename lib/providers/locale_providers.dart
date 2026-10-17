import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';

/// User language preference: French (default) or English.
///
/// The value is loaded from local storage on start and every change is written
/// back, so the choice survives an app restart without any account. It follows
/// the same pattern as [ThemeModeNotifier].
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storageLoader) : super(_defaultLocale) {
    _load();
  }

  static const Locale _defaultLocale = Locale('fr');

  final StorageLoader _storageLoader;

  /// Set as soon as the user picks a language, so the load that is still
  /// running when the app starts never overrides that choice.
  bool _userChoice = false;

  Future<void> _load() async {
    Locale stored;
    try {
      final storage = await _storageLoader();
      stored = await storage.getLocale();
    } catch (_) {
      // Without storage French, the default, is used.
      stored = _defaultLocale;
    }
    if (_userChoice) return;
    state = stored;
  }

  Future<void> setLocale(Locale locale) async {
    _userChoice = true;
    state = locale;
    try {
      final storage = await _storageLoader();
      await storage.saveLocale(locale);
    } catch (_) {
      // The choice is applied even when it cannot be persisted yet.
    }
  }
}

/// Current language of the app, persisted locally.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(() => ref.read(storageServiceProvider.future));
});