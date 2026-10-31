import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';

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

/// Localized name of a question variation.
extension QuestionVariationLocalizations on QuestionVariation {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case QuestionVariation.whichCameFirst:
        return l10n.questionVariationChronology;
      case QuestionVariation.guessTheCountryProgressive:
        return l10n.questionVariationClues;
      case QuestionVariation.guessTheCountryFlag:
        return l10n.questionVariationFlag;
      case QuestionVariation.guessTheCountryCapital:
        return l10n.questionVariationCapital;
      case QuestionVariation.guessTheCountrySilhouette:
        return l10n.questionVariationSilhouette;
      case QuestionVariation.factOrCapTrueFalse:
        return l10n.questionVariationTrueFalse;
      case QuestionVariation.factOrCapTwoTruthsOneLie:
        return l10n.questionVariationTwoTruthsOneLie;
      case QuestionVariation.factOrCapIdentifyFalse:
        return l10n.questionVariationIdentifyFalse;
      case QuestionVariation.putInOrderChronological:
        return l10n.questionVariationChronology;
      case QuestionVariation.putInOrderByProperty:
        return l10n.questionVariationByProperty;
      case QuestionVariation.howMuchQuantity:
        return l10n.questionVariationQuantity;
      case QuestionVariation.howMuchDate:
        return l10n.questionVariationDate;
      case QuestionVariation.howMuchDistance:
        return l10n.questionVariationDistance;
      case QuestionVariation.howMuchPopulation:
        return l10n.questionVariationPopulation;
    }
  }
}

/// Localized message for a [SessionConfigError], usable from any UI layer that
/// has an [AppLocalizations] instance.
extension SessionConfigErrorMessage on SessionConfigError {
  String message(AppLocalizations l10n) {
    switch (this) {
      case SessionConfigError.minPlayers:
        return l10n.sessionConfigErrorMinPlayers;
      case SessionConfigError.maxPlayers:
        return l10n.sessionConfigErrorMaxPlayers;
      case SessionConfigError.uniqueNames:
        return l10n.sessionConfigErrorUniqueNames;
      case SessionConfigError.noMode:
        return l10n.sessionConfigErrorNoMode;
      case SessionConfigError.durationTooShort:
        return l10n.sessionConfigErrorDurationTooShort;
      case SessionConfigError.questionCountTooLow:
        return l10n.sessionConfigErrorQuestionCountTooLow;
    }
  }
}

/// Localized message for an [AwardResult], usable from any UI layer that has
/// an [AppLocalizations] instance.
extension AwardResultMessage on AwardResult {
  String message(AppLocalizations l10n) {
    switch (this) {
      case AwardResult.awarded:
        return l10n.awardResultAwarded;
      case AwardResult.unknownPlayer:
        return l10n.awardResultUnknownPlayer;
      case AwardResult.alreadyAwarded:
        return l10n.awardResultAlreadyAwarded;
      case AwardResult.invalidatedQuestion:
        return l10n.awardResultInvalidatedQuestion;
      case AwardResult.sessionNotActive:
        return l10n.awardResultSessionNotActive;
      case AwardResult.wrongOrder:
        return l10n.awardResultWrongOrder;
    }
  }
}
