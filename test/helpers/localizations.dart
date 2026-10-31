import 'package:flutter/material.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/app_localizations_fr.dart';

/// The app locale forced to French, its default.
///
/// Widget tests run with an en_US platform locale; a test MaterialApp without
/// an explicit locale would resolve to English and break the French
/// assertions.
const Locale kTestLocale = Locale('fr');

/// A French [AppLocalizations] instance for tests that need to call
/// localization-dependent methods outside a widget tree.
AppLocalizations get testL10n => AppLocalizationsFr();

/// The app's localization delegates, for tests that build their own
/// MaterialApp around a localized screen (Home, Settings).
const List<LocalizationsDelegate<dynamic>> kTestLocalizationDelegates =
    AppLocalizations.localizationsDelegates;

/// The app's supported locales (fr, en).
const List<Locale> kTestSupportedLocales = AppLocalizations.supportedLocales;
