import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Localized title of a game mode, usable from any screen that has an
/// [AppLocalizations] instance.
extension GameModeTitle on GameMode {
  String title(AppLocalizations l10n) {
    switch (this) {
      case GameMode.whichCameFirst:
        return l10n.gameModeWhichCameFirst;
      case GameMode.guessTheCountry:
        return l10n.gameModeGuessTheCountry;
      case GameMode.factOrCap:
        return l10n.gameModeFactOrCap;
      case GameMode.putInOrder:
        return l10n.gameModePutInOrder;
      case GameMode.howMuch:
        return l10n.gameModeHowMuch;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case GameMode.whichCameFirst:
        return l10n.gameModeWhichCameFirstDesc;
      case GameMode.guessTheCountry:
        return l10n.gameModeGuessTheCountryDesc;
      case GameMode.factOrCap:
        return l10n.gameModeFactOrCapDesc;
      case GameMode.putInOrder:
        return l10n.gameModePutInOrderDesc;
      case GameMode.howMuch:
        return l10n.gameModeHowMuchDesc;
    }
  }
}

/// Localized name of a question category.
extension CategoryLocalizations on QuestionCategory {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case QuestionCategory.history:
        return l10n.categoryHistory;
      case QuestionCategory.science:
        return l10n.categoryScience;
      case QuestionCategory.geography:
        return l10n.categoryGeography;
      case QuestionCategory.arts:
        return l10n.categoryArts;
      case QuestionCategory.sports:
        return l10n.categorySports;
      case QuestionCategory.technology:
        return l10n.categoryTechnology;
      case QuestionCategory.nature:
        return l10n.categoryNature;
      case QuestionCategory.general:
        return l10n.categoryGeneral;
      case QuestionCategory.africa:
        return l10n.categoryAfrica;
    }
  }
}

/// Localized name of a difficulty level.
extension DifficultyLocalizations on Difficulty {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case Difficulty.easy:
        return l10n.difficultyEasy;
      case Difficulty.medium:
        return l10n.difficultyMedium;
      case Difficulty.hard:
        return l10n.difficultyHard;
    }
  }
}
