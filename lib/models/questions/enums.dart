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
  africa,
}

enum Difficulty { easy, medium, hard }

enum ContentReviewStatus { draft, reviewed, approved, deprecated }

enum Language { french, english }

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

/// JSON discriminator of a question: the `type` field of a stored question
/// selects which [BaseQuestion] subclass decodes it.
///
/// [GameMode] cannot serve that purpose: several variations of one mode are
/// stored in the same file, and a future mode could keep questions of two
/// different shapes.
enum QuestionType {
  whichCameFirst,
  guessTheCountry,
  factOrCap,
  putInOrder,
  howMuch,
}
