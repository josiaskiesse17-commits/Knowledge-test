enum GameMode {
  whichCameFirst,
  guessTheCountry,
  factOrCap,
  putInOrder,
  howMuch,
}

enum QuestionCategory {
  history,
  science,
  geography,
  arts,
  sports,
  technology,
  nature,
  general,
}

enum Difficulty {
  easy,
  medium,
  hard,
}

enum ContentReviewStatus {
  draft,
  reviewed,
  approved,
  deprecated,
}

enum Language {
  french,
  english,
}

enum QuestionVariation {
  whichCameFirst,
  guessTheCountryProgressive,
  guessTheCountryFlag,
  guessTheCountryCapital,
  guessTheCountrySilhouette,
  factOrCapTrueFalse,
  factOrCapTwoTruthsOneLie,
  factOrCapIdentifyFalse,
  putInOrderChronological,
  putInOrderByProperty,
  howMuchQuantity,
  howMuchDate,
  howMuchDistance,
  howMuchPopulation,
}

extension GameModeExtension on GameMode {
  String get displayNameFr {
    switch (this) {
      case GameMode.whichCameFirst:
        return 'Lequel en premier ?';
      case GameMode.guessTheCountry:
        return 'Devine le pays';
      case GameMode.factOrCap:
        return 'Fait ou Fake';
      case GameMode.putInOrder:
        return 'Mets dans l\'ordre';
      case GameMode.howMuch:
        return 'Combien ?';
    }
  }

  String get descriptionFr {
    switch (this) {
      case GameMode.whichCameFirst:
        return 'Comparez des événements historiques, découvertes et inventions';
      case GameMode.guessTheCountry:
        return 'Identifiez des pays à partir d\'indices progressifs, drapeaux, capitales ou silhouettes';
      case GameMode.factOrCap:
        return 'Vrai/faux, deux vérités un mensonge, identifiez la fausse affirmation';
      case GameMode.putInOrder:
        return 'Rangez des éléments chronologiquement ou par une propriété mesurable';
      case GameMode.howMuch:
        return 'Estimation numérique : quantités, dates, distances, populations';
    }
  }
}

extension QuestionCategoryExtension on QuestionCategory {
  String get displayNameFr {
    switch (this) {
      case QuestionCategory.history:
        return 'Histoire';
      case QuestionCategory.science:
        return 'Sciences';
      case QuestionCategory.geography:
        return 'Géographie';
      case QuestionCategory.arts:
        return 'Arts et Culture';
      case QuestionCategory.sports:
        return 'Sports';
      case QuestionCategory.technology:
        return 'Technologie';
      case QuestionCategory.nature:
        return 'Nature';
      case QuestionCategory.general:
        return 'Culture Générale';
    }
  }
}

extension DifficultyExtension on Difficulty {
  String get displayNameFr {
    switch (this) {
      case Difficulty.easy:
        return 'Facile';
      case Difficulty.medium:
        return 'Moyen';
      case Difficulty.hard:
        return 'Difficile';
    }
  }
}