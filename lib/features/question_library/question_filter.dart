import 'package:knowledge_test/models/questions/index.dart';

/// Filters applied to the question library.
///
/// The logic is pure so it can be unit tested without any widget: an empty
/// filter accepts every question, and each activated filter narrows the list
/// further. An unknown filter combination simply returns an empty list.
class QuestionFilter {
  const QuestionFilter({
    this.modes = const {},
    this.categories = const {},
    this.difficulties = const {},
    this.variations = const {},
    this.search = '',
  });

  final Set<GameMode> modes;
  final Set<QuestionCategory> categories;
  final Set<Difficulty> difficulties;
  final Set<QuestionVariation> variations;

  /// Free text matched against the question text, its explanation and its id.
  final String search;

  bool get isActive =>
      modes.isNotEmpty ||
      categories.isNotEmpty ||
      difficulties.isNotEmpty ||
      variations.isNotEmpty ||
      search.isNotEmpty;

  /// Count of the active filters, useful for a "clear" affordance.
  int get activeCount =>
      modes.length +
      categories.length +
      difficulties.length +
      variations.length +
      (search.isEmpty ? 0 : 1);

  /// Applies the filters to [questions].
  ///
  /// The order of [questions] is preserved, so the library keeps a stable
  /// ordering whatever the filters are.
  List<BaseQuestion> apply(List<BaseQuestion> questions) {
    final needle = _normalize(search);
    return questions.where((question) {
      if (modes.isNotEmpty && !modes.contains(question.mode)) return false;
      if (categories.isNotEmpty && !categories.contains(question.category)) {
        return false;
      }
      if (difficulties.isNotEmpty && !difficulties.contains(question.difficulty)) {
        return false;
      }
      if (variations.isNotEmpty && !variations.contains(question.variation)) {
        return false;
      }
      if (needle.isNotEmpty && !_matches(question, needle)) return false;
      return true;
    }).toList();
  }

  QuestionFilter copyWith({
    Set<GameMode>? modes,
    Set<QuestionCategory>? categories,
    Set<Difficulty>? difficulties,
    Set<QuestionVariation>? variations,
    String? search,
  }) {
    return QuestionFilter(
      modes: modes ?? this.modes,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
      variations: variations ?? this.variations,
      search: search ?? this.search,
    );
  }

  /// Adds or removes [mode] from the selection.
  QuestionFilter toggleMode(GameMode mode) => copyWith(
        modes: _toggled(modes, mode),
        // A mode change can make the variation selection inconsistent, so it
        // is cleared to keep the badge counts meaningful.
        variations: _consistentVariations(_toggled(modes, mode), variations),
      );

  QuestionFilter toggleCategory(QuestionCategory category) =>
      copyWith(categories: _toggled(categories, category));

  QuestionFilter toggleDifficulty(Difficulty difficulty) =>
      copyWith(difficulties: _toggled(difficulties, difficulty));

  QuestionFilter toggleVariation(QuestionVariation variation) =>
      copyWith(variations: _toggled(variations, variation));

  QuestionFilter withSearch(String value) => copyWith(search: value);

  /// Returns a filter with every constraint removed.
  QuestionFilter get cleared => const QuestionFilter();

  static Set<T> _toggled<T>(Set<T> current, T value) {
    final next = {...current};
    if (!next.remove(value)) next.add(value);
    return next;
  }

  /// Keeps only the variations that belong to [modes]; empty modes mean every
  /// variation stays allowed.
  static Set<QuestionVariation> _consistentVariations(
    Set<GameMode> modes,
    Set<QuestionVariation> variations,
  ) {
    if (modes.isEmpty || variations.isEmpty) return variations;
    return variations
        .where((v) => modes.contains(v.mode))
        .toSet();
  }

  static bool _matches(BaseQuestion question, String needle) =>
      _normalize(question.text).contains(needle) ||
      _normalize(question.explanationFr).contains(needle) ||
      _normalize(question.id).contains(needle) ||
      _normalize(question.sourceReference).contains(needle);

  /// Accent-insensitive comparison, so "decouverte" finds "découverte" and
  /// "combien" finds "Combien ?".
  static const _accentMap = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
    'ç': 'c',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'ñ': 'n',
    'ý': 'y',
  };

  static String _normalize(String value) {
    final lower = value.toLowerCase();
    return lower
        .split('')
        .map((char) => _accentMap[char] ?? char)
        .join()
        .trim();
  }
}

/// Game mode a question variation belongs to.
extension QuestionVariationMode on QuestionVariation {
  GameMode get mode => switch (this) {
        QuestionVariation.whichCameFirst => GameMode.whichCameFirst,
        QuestionVariation.guessTheCountryProgressive ||
        QuestionVariation.guessTheCountryFlag ||
        QuestionVariation.guessTheCountryCapital ||
        QuestionVariation.guessTheCountrySilhouette =>
          GameMode.guessTheCountry,
        QuestionVariation.factOrCapTrueFalse ||
        QuestionVariation.factOrCapTwoTruthsOneLie ||
        QuestionVariation.factOrCapIdentifyFalse =>
          GameMode.factOrCap,
        QuestionVariation.putInOrderChronological ||
        QuestionVariation.putInOrderByProperty =>
          GameMode.putInOrder,
        QuestionVariation.howMuchQuantity ||
        QuestionVariation.howMuchDate ||
        QuestionVariation.howMuchDistance ||
        QuestionVariation.howMuchPopulation =>
          GameMode.howMuch,
      };

  /// Short French label of the variation, as shown in the question body.
  String get labelFr => switch (this) {
        QuestionVariation.whichCameFirst => 'Chronologie',
        QuestionVariation.guessTheCountryProgressive => 'Indices',
        QuestionVariation.guessTheCountryFlag => 'Drapeau',
        QuestionVariation.guessTheCountryCapital => 'Capitale',
        QuestionVariation.guessTheCountrySilhouette => 'Silhouette',
        QuestionVariation.factOrCapTrueFalse => 'Vrai ou faux',
        QuestionVariation.factOrCapTwoTruthsOneLie => 'Deux vérités, un mensonge',
        QuestionVariation.factOrCapIdentifyFalse => 'Trouve la fausse affirmation',
        QuestionVariation.putInOrderChronological => 'Chronologie',
        QuestionVariation.putInOrderByProperty => 'Par propriété',
        QuestionVariation.howMuchQuantity => 'Quantité',
        QuestionVariation.howMuchDate => 'Date',
        QuestionVariation.howMuchDistance => 'Distance',
        QuestionVariation.howMuchPopulation => 'Population',
      };
}
