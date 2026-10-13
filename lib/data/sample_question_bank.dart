import 'package:knowledge_test/models/questions/index.dart';

/// Sample question bank used to bootstrap the app before a persistent
/// question library is available.
///
/// Every question is written in French, carries a source reference and a
/// concise explanation. `factGroupId` groups questions that rely on the same
/// underlying fact (e.g. a fact asked both as a date estimate and as a
/// chronology comparison). Questions that do not share a fact get their own
/// unique group id.
class SampleQuestionBank {
  SampleQuestionBank._();

  static final DateTime _createdAt = DateTime.utc(2025, 1, 1);

  static List<BaseQuestion> get questions => [
        ..._whichCameFirst,
        ..._guessTheCountry,
        ..._factOrCap,
        ..._putInOrder,
        ..._howMuch,
      ];

  // ---------------------------------------------------------------------------
  // 1. Which Came First?
  // ---------------------------------------------------------------------------

  static final List<WhichCameFirstQuestion> _whichCameFirst = [
    WhichCameFirstQuestion(
      id: 'wcf-001',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : le premier pas de l\'Homme sur la Lune '
          'ou le premier vol spatial habité par une femme ?',
      explanationFr: 'Valentina Alekseevna Tereshkova est devenue la première femme '
          'dans l\'espace le 16 juin 1963 à bord de Vostok 6, soit environ six ans '
          'avant le premier pas sur la Lune d\'Apollo 11 le 20 juillet 1969.',
      sourceReference: 'NASA, fiches de mission Apollo 11 et Vostok 6',
      factGroupId: 'fg-moon-landing-1969',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-001-e1',
          label: 'Premier pas de l\'Homme sur la Lune (Apollo 11)',
          date: DateTime.utc(1969, 7, 20),
        ),
        ChronologyEvent(
          id: 'wcf-001-e2',
          label: 'Premier vol spatial habité par une femme (Vostok 6)',
          date: DateTime.utc(1963, 6, 16),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-002',
      category: QuestionCategory.technology,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : l\'imprimerie à caractères mobiles de '
          'Gutenberg ou le brevet du téléphone de Bell ?',
      explanationFr: 'L\'imprimerie moderne de Johannes Gutenberg est datée '
          'd\'environ 1450 en Europe centrale, tandis que le brevet du téléphone '
          'd\'Alexander Graham Bell date du 7 mars 1876, soit plus de quatre '
          'siècles plus tard.',
      sourceReference: 'Encyclopaedia Britannica, articles « Printing press » et « Telephone »',
      factGroupId: 'fg-gutenberg-press-1450',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-002-e1',
          label: 'Imprimerie à caractères mobiles de Gutenberg',
          date: DateTime.utc(1450, 1, 1),
        ),
        ChronologyEvent(
          id: 'wcf-002-e2',
          label: 'Brevet du téléphone (Alexander Graham Bell)',
          date: DateTime.utc(1876, 3, 7),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-003',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la découverte de la pénicilline par '
          'Fleming ou la publication de la structure en double hélice de l\'ADN ?',
      explanationFr: 'Alexander Fleming observe l\'action antibiotique de la '
          'pénicilline en septembre 1928. La description de la structure en double '
          'hélice de l\'ADN par Watson et Crick est publiée en avril 1953.',
      sourceReference: 'Nature 171 (1953), article de Watson et Crick ; Nobel Prize, Fleming 1945',
      factGroupId: 'fg-penicillin-1928',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-003-e1',
          label: 'Découverte de la pénicilline (Alexander Fleming)',
          date: DateTime.utc(1928, 9, 1),
        ),
        ChronologyEvent(
          id: 'wcf-003-e2',
          label: 'Publication de la structure en double hélice de l\'ADN',
          date: DateTime.utc(1953, 4, 25),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-004',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : la chute du mur de Berlin ou la '
          'dissolution officielle de l\'URSS ?',
      explanationFr: 'Le mur de Berlin est ouvert le 9 novembre 1989. L\'URSS est '
          'officiellement dissoute le 26 décembre 1991, soit plus de deux ans plus tard.',
      sourceReference: 'Encyclopaedia Britannica, articles « Berlin Wall » et « Soviet Union »',
      factGroupId: 'fg-berlin-wall-1989',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-004-e1',
          label: 'Chute du mur de Berlin',
          date: DateTime.utc(1989, 11, 9),
        ),
        ChronologyEvent(
          id: 'wcf-004-e2',
          label: 'Dissolution officielle de l\'URSS',
          date: DateTime.utc(1991, 12, 26),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-005',
      category: QuestionCategory.sports,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : les premiers Jeux olympiques de '
          'l\'ère moderne ou la première Coupe du monde de football ?',
      explanationFr: 'Les premiers Jeux olympiques de l\'ère moderne ont lieu à '
          'Athènes en avril 1896. La première Coupe du monde de football est '
          'organisée en Uruguay en 1930.',
      sourceReference: 'Comité international olympique ; FIFA, coupes du monde 1930',
      factGroupId: 'fg-modern-olympics-1896',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-005-e1',
          label: 'Jeux olympiques de l\'ère moderne à Athènes',
          date: DateTime.utc(1896, 4, 6),
        ),
        ChronologyEvent(
          id: 'wcf-005-e2',
          label: 'Première Coupe du monde de football (Uruguay)',
          date: DateTime.utc(1930, 7, 13),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-006',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : le lancement de Spoutnik 1 ou le '
          'premier vol spatial habité de Youri Gagarine ?',
      explanationFr: 'Spoutnik 1, premier satellite artificiel, est lancé le '
          '4 octobre 1957. Le vol de Gagarine à bord de Vostok 1 a lieu le '
          '12 avril 1961, soit trois ans et demi plus tard.',
      sourceReference: 'NASA, historique des débuts de l\'ère spatiale',
      factGroupId: 'fg-sputnik-1957',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-006-e1',
          label: 'Lancement de Spoutnik 1',
          date: DateTime.utc(1957, 10, 4),
        ),
        ChronologyEvent(
          id: 'wcf-006-e2',
          label: 'Premier vol spatial habité (Vostok 1)',
          date: DateTime.utc(1961, 4, 12),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
  ];

  // ---------------------------------------------------------------------------
  // 2. Guess the Country
  // ---------------------------------------------------------------------------

  static final List<GuessTheCountryQuestion> _guessTheCountry = [
    GuessTheCountryQuestion(
      id: 'gtc-001',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays d\'Asie de l\'Est à partir des indices.',
      explanationFr: 'Le Japon est un archipel de l\'Asie de l\'Est dont la '
          'capitale est Tokyo, qui abrite le mont Fuji et dont la monnaie est le yen.',
      sourceReference: 'Encyclopaedia Britannica, article « Japan »',
      factGroupId: 'fg-country-japan',
      createdAt: _createdAt,
      targetCountry: 'Japon',
      targetCountryCode: 'JP',
      acceptedAnswers: ['Japon', 'japon', 'Japan', 'Nippon', 'Nihon'],
      capital: 'Tokyo',
      continent: 'Asie',
      clues: [
        CountryClue(text: 'C\'est un archipel composé de milliers d\'îles.', order: 1),
        CountryClue(text: 'Sa capitale est l\'une des plus peuplées du monde.', order: 2),
        CountryClue(text: 'Le mont Fuji, un volcan emblématique, s\'y trouve.', order: 3),
        CountryClue(text: 'Sa monnaie est le yen.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-002',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays d\'Amérique du Sud à partir des indices.',
      explanationFr: 'Le Brésil est le plus grand pays d\'Amérique du Sud. Sa '
          'capitale Brasília a été construite pour devenir capitale fédérale, la '
          'langue officielle est le portugais et la majeure partie de la forêt '
          'amazonienne se trouve sur son territoire.',
      sourceReference: 'Encyclopaedia Britannica, article « Brazil »',
      factGroupId: 'fg-country-brazil',
      createdAt: _createdAt,
      targetCountry: 'Brésil',
      targetCountryCode: 'BR',
      acceptedAnswers: ['Brésil', 'Brésil', 'Brazil', 'Bresil'],
      capital: 'Brasília',
      continent: 'Amérique du Sud',
      clues: [
        CountryClue(text: 'C\'est le plus grand pays d\'Amérique du Sud par sa superficie.', order: 1),
        CountryClue(text: 'Sa capitale actuelle a été construite exprès pour ce rôle.', order: 2),
        CountryClue(text: 'La langue officielle y est le portugais.', order: 3),
        CountryClue(text: 'Une grande partie de la forêt amazonienne s\'y trouve.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-003',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays d\'Afrique du Nord-Est à partir des indices.',
      explanationFr: 'L\'Égypte est située au nord-est de l\'Afrique, traversée '
          'par le Nil. Les pyramides de Gizeh se trouvent près de sa capitale, Le Caire.',
      sourceReference: 'Encyclopaedia Britannica, article « Egypt »',
      factGroupId: 'fg-country-egypt',
      createdAt: _createdAt,
      targetCountry: 'Égypte',
      targetCountryCode: 'EG',
      acceptedAnswers: ['Égypte', 'Egypte', 'Egypt', 'Egipto'],
      capital: 'Le Caire',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'Ce pays est situé au nord-est de l\'Afrique.', order: 1),
        CountryClue(text: 'Un très long fleuve le traverse du sud au nord.', order: 2),
        CountryClue(text: 'Les pyramides de Gizeh se trouvent sur son territoire.', order: 3),
        CountryClue(text: 'Sa capitale est Le Caire.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-004',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays d\'Amérique du Nord à partir des indices.',
      explanationFr: 'Le Canada est le deuxième pays du monde par sa superficie '
          'derrière la Russie, possède le plus long littoral du monde, a pour '
          'capitale Ottawa et un drapeau orné d\'une feuille d\'érable.',
      sourceReference: 'Encyclopaedia Britannica, article « Canada »',
      factGroupId: 'fg-country-canada',
      createdAt: _createdAt,
      targetCountry: 'Canada',
      targetCountryCode: 'CA',
      acceptedAnswers: ['Canada'],
      capital: 'Ottawa',
      continent: 'Amérique du Nord',
      clues: [
        CountryClue(text: 'C\'est le deuxième plus grand pays du monde par sa superficie.', order: 1),
        CountryClue(text: 'Son littoral est le plus long du monde.', order: 2),
        CountryClue(text: 'Sa capitale est Ottawa.', order: 3),
        CountryClue(text: 'Son drapeau porte une feuille d\'érable.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-005',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays-continent à partir des indices.',
      explanationFr: 'L\'Australie est à la fois un pays et un continent. Sa '
          'capitale est Canberra, la Grande Barrière de corail borde ses côtes et '
          'l\'Opéra de Sydney est l\'un de ses monuments les plus connus.',
      sourceReference: 'Encyclopaedia Britannica, article « Australia »',
      factGroupId: 'fg-country-australia',
      createdAt: _createdAt,
      targetCountry: 'Australie',
      targetCountryCode: 'AU',
      acceptedAnswers: ['Australie', 'Australia'],
      capital: 'Canberra',
      continent: 'Océanie',
      clues: [
        CountryClue(text: 'C\'est à la fois un pays et un continent.', order: 1),
        CountryClue(text: 'Sa capitale n\'est ni Sydney ni Melbourne.', order: 2),
        CountryClue(text: 'La plus grande structure vivante du monde borde ses côtes.', order: 3),
        CountryClue(text: 'L\'Opéra de Sydney s\'y trouve.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-006',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Devine ce pays d\'Afrique de l\'Est à partir des indices.',
      explanationFr: 'Le Kenya est traversé par l\'équateur, a pour langues '
          'officielles le swahili et l\'anglais, pour capitale Nairobi et abrite '
          'la réserve nationale du Masai Mara.',
      sourceReference: 'Encyclopaedia Britannica, article « Kenya »',
      factGroupId: 'fg-country-kenya',
      createdAt: _createdAt,
      targetCountry: 'Kenya',
      targetCountryCode: 'KE',
      acceptedAnswers: ['Kenya'],
      capital: 'Nairobi',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'L\'équateur traverse ce pays.', order: 1),
        CountryClue(text: 'Le swahili et l\'anglais y sont langues officielles.', order: 2),
        CountryClue(text: 'Sa capitale est Nairobi.', order: 3),
        CountryClue(text: 'La réserve du Masai Mara s\'y trouve.', order: 4),
      ],
    ),
  ];

  // ---------------------------------------------------------------------------
  // 3. Fact or Cap
  // ---------------------------------------------------------------------------

  static final List<FactOrCapQuestion> _factOrCap = [
    FactOrCapQuestion(
      id: 'foc-001',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Fait ou fake : le plus grand océan du monde est l\'océan Pacifique.',
      explanationFr: 'L\'océan Pacifique couvre environ 165 millions de km², soit '
          'plus que la superficie terrestre totale de tous les continents réunis, '
          'ce qui en fait bien le plus grand océan.',
      sourceReference: 'NOAA, National Ocean Service ; Encyclopaedia Britannica',
      factGroupId: 'fg-pacific-largest',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-001-s1',
          text: 'L\'océan Pacifique est le plus grand océan du monde.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-002',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : la Grande Muraille de Chine est visible à l\'œil nu '
          'depuis la Lune.',
      explanationFr: 'C\'est une légende : avec ses quelques mètres de large, la '
          'Grande Muraille est bien trop étroite pour être distinguée à l\'œil nu '
          'depuis la Lune, distante d\'environ 384 000 km.',
      sourceReference: 'NASA, questions fréquentes sur la Lune',
      factGroupId: 'fg-great-wall-myth',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-002-s1',
          text: 'La Grande Muraille de Chine est visible à l\'œil nu depuis la Lune.',
          isTrue: false,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-003',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Deux vérités et un mensonge sur le climat et les déserts : identifie le mensonge.',
      explanationFr: 'L\'Antarctique est bien le plus grand désert du monde au sens '
          'climatologique (précipitations inférieures à 250 mm par an), et le pôle '
          'Sud est plus froid que le pôle Nord. En revanche le Sahara n\'est que le '
          'plus grand désert chaud, l\'Antarctique étant plus vaste.',
      sourceReference: 'Encyclopaedia Britannica, articles « Desert » et « Sahara »',
      factGroupId: 'fg-desert-records',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-003-s1',
          text: 'Le pôle Sud est plus froid que le pôle Nord.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-003-s2',
          text: 'L\'Antarctique est le plus grand désert du monde.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-003-s3',
          text: 'Le Sahara est le plus grand désert du monde.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-004',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Deux vérités et un mensonge sur les îles et les continents : identifie le mensonge.',
      explanationFr: 'Le Groenland est bien la plus grande île du monde (hors '
          'continents) et l\'Australie est le plus petit continent. En revanche '
          'Bornéo, avec environ 748 000 km², est bien plus petite que l\'Australie '
          'et ses 7,7 millions de km².',
      sourceReference: 'Encyclopaedia Britannica, articles « Greenland » et « Borneo »',
      factGroupId: 'fg-island-continent',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-004-s1',
          text: 'Le Groenland est la plus grande île du monde.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-004-s2',
          text: 'L\'Australie est le plus petit continent.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-004-s3',
          text: 'Bornéo est plus grande que l\'Australie.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-005',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Une seule affirmation est fausse sur les musées : laquelle ?',
      explanationFr: 'Le Cri d\'Edvard Munch est conservé dans les musées d\'Oslo '
          '(Nasjonalmuseet et Munchmuseet), et non au British Museum de Londres. '
          'Les trois autres affirmations sont exactes.',
      sourceReference: 'Musée du Louvre ; Museo Reina Sofía ; MoMA ; Nasjonalmuseet',
      factGroupId: 'fg-art-museums',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-005-s1',
          text: 'La Joconde est exposée au Louvre, à Paris.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-005-s2',
          text: 'Le Guernica de Picasso est conservé au musée Reina Sofía, à Madrid.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-005-s3',
          text: 'La Nuit étoilée de Van Gogh est conservée au Museum of Modern Art de New York.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-005-s4',
          text: 'Le Cri de Munch est conservé au British Museum, à Londres.',
          isTrue: false,
        ),
      ],
      falseStatementIndex: 3,
    ),
    FactOrCapQuestion(
      id: 'foc-006',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Une seule affirmation est fausse sur les métaux : laquelle ?',
      explanationFr: 'Le métal le plus dense est l\'osmium (environ 22,6 g/cm³), '
          'et non le plomb (11,3 g/cm³). L\'or a bien pour symbole Au, le tungstène '
          'possède le point de fusion le plus élevé des métaux et le mercure est '
          'liquide à température ambiante.',
      sourceReference: 'Royal Society of Chemistry, tableau périodique',
      factGroupId: 'fg-metal-records',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-006-s1',
          text: 'Le symbole chimique de l\'or est Au.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-006-s2',
          text: 'Le tungstène possède le point de fusion le plus élevé des métaux.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-006-s3',
          text: 'Le mercure est liquide à température ambiante.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-006-s4',
          text: 'Le plomb est le métal le plus dense.',
          isTrue: false,
        ),
      ],
      falseStatementIndex: 3,
    ),
    FactOrCapQuestion(
      id: 'foc-007',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Une seule affirmation est fausse sur les étoiles : laquelle ?',
      explanationFr: 'Proxima Centauri, bien qu\'elle soit l\'étoile la plus proche '
          'du Soleil, a une magnitude apparente d\'environ 11 : elle est bien trop '
          'faible pour être vue à l\'œil nu, contrairement à Sirius ou Véga.',
      sourceReference: 'ESA, données sur Proxima Centauri',
      factGroupId: 'fg-star-distances',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-007-s1',
          text: 'La lumière du Soleil met environ 8 minutes à parvenir à la Terre.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-007-s2',
          text: 'Le Soleil est l\'étoile la plus proche de la Terre.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-007-s3',
          text: 'Proxima Centauri est visible à l\'œil nu depuis la Terre.',
          isTrue: false,
        ),
        FactStatement(
          id: 'foc-007-s4',
          text: 'La Voie lactée est la galaxie qui contient le Système solaire.',
          isTrue: true,
        ),
      ],
      falseStatementIndex: 2,
    ),
  ];

  // ---------------------------------------------------------------------------
  // 4. Put These in Order
  // ---------------------------------------------------------------------------

  static final List<PutInOrderQuestion> _putInOrder = [
    PutInOrderQuestion(
      id: 'pio-001',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Range ces étapes de la communication à distance de la plus ancienne '
          'à la plus récente.',
      explanationFr: 'L\'ordre chronologique est : le télégraphe électrique de '
          'Morse (1837), le brevet du téléphone (1876), les premières '
          'démonstrations de télégraphie sans fil de Marconi (1895), la première '
          'démonstration de télévision par Baird (1926) puis l\'ouverture du Web '
          'au public au CERN (1991).',
      sourceReference: 'Encyclopaedia Britannica, histoire des télécommunications',
      factGroupId: 'fg-communication-milestones',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-001-i1',
          label: 'Télégraphe électrique de Samuel Morse',
          referenceValue: 1837,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-001-i2',
          label: 'Brevet du téléphone (Alexander Graham Bell)',
          referenceValue: 1876,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-001-i3',
          label: 'Premières démonstrations de télégraphie sans fil (Marconi)',
          referenceValue: 1895,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-001-i4',
          label: 'Première démonstration de télévision (John Logie Baird)',
          referenceValue: 1926,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-001-i5',
          label: 'Ouverture du Web au public (CERN)',
          referenceValue: 1991,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-001-i1', 'pio-001-i2', 'pio-001-i3', 'pio-001-i4', 'pio-001-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-002',
      category: QuestionCategory.history,
      difficulty: Difficulty.medium,
      text: 'Range ces événements du plus ancien au plus récent.',
      explanationFr: 'L\'ordre est : chute de Constantinople (1453), arrivée de '
          'Christophe Colomb aux Amériques (1492), prise de la Bastille (1789), '
          'bataille de Waterloo (1815) puis armistice de 1918.',
      sourceReference: 'Encyclopaedia Britannica, articles historiques correspondants',
      factGroupId: 'fg-historical-timeline',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-002-i1',
          label: 'Prise de la Bastille',
          referenceValue: 1789,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-002-i2',
          label: 'Chute de Constantinople',
          referenceValue: 1453,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-002-i3',
          label: 'Christophe Colomb atteint les Amériques',
          referenceValue: 1492,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-002-i4',
          label: 'Bataille de Waterloo',
          referenceValue: 1815,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-002-i5',
          label: 'Armistice de la Première Guerre mondiale',
          referenceValue: 1918,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-002-i2', 'pio-002-i3', 'pio-002-i1', 'pio-002-i4', 'pio-002-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-003',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Range ces planètes de la plus proche à la plus éloignée du Soleil.',
      explanationFr: 'L\'ordre des distances moyennes au Soleil est : Mercure '
          '(57,9 millions de km), Vénus (108,2), Terre (149,6), Mars (227,9) puis '
          'Jupiter (778,5 millions de km).',
      sourceReference: 'NASA, fiches planétaires du Système solaire',
      factGroupId: 'fg-planet-distances',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-003-i1',
          label: 'Mercure',
          referenceValue: 57.9,
          unit: 'millions de km',
        ),
        OrderableItem(
          id: 'pio-003-i2',
          label: 'Vénus',
          referenceValue: 108.2,
          unit: 'millions de km',
        ),
        OrderableItem(
          id: 'pio-003-i3',
          label: 'Terre',
          referenceValue: 149.6,
          unit: 'millions de km',
        ),
        OrderableItem(
          id: 'pio-003-i4',
          label: 'Mars',
          referenceValue: 227.9,
          unit: 'millions de km',
        ),
        OrderableItem(
          id: 'pio-003-i5',
          label: 'Jupiter',
          referenceValue: 778.5,
          unit: 'millions de km',
        ),
      ],
      correctOrderIds: ['pio-003-i1', 'pio-003-i2', 'pio-003-i3', 'pio-003-i4', 'pio-003-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-004',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Range ces sommets du moins élevé au plus élevé.',
      explanationFr: 'L\'ordre des altitudes est : Eiger (3 967 m), Matterhorn '
          '(4 478 m), Mont Blanc (4 806 m), Kilimandjaro (5 895 m) puis Everest '
          '(8 849 m), point culminant de la Terre.',
      sourceReference: 'Encyclopaedia Britannica, articles de chaque sommet',
      factGroupId: 'fg-mountain-heights',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-004-i1',
          label: 'Eiger',
          referenceValue: 3967,
          unit: 'm',
        ),
        OrderableItem(
          id: 'pio-004-i2',
          label: 'Matterhorn',
          referenceValue: 4478,
          unit: 'm',
        ),
        OrderableItem(
          id: 'pio-004-i3',
          label: 'Mont Blanc',
          referenceValue: 4806,
          unit: 'm',
        ),
        OrderableItem(
          id: 'pio-004-i4',
          label: 'Kilimandjaro',
          referenceValue: 5895,
          unit: 'm',
        ),
        OrderableItem(
          id: 'pio-004-i5',
          label: 'Everest',
          referenceValue: 8849,
          unit: 'm',
        ),
      ],
      correctOrderIds: ['pio-004-i1', 'pio-004-i2', 'pio-004-i3', 'pio-004-i4', 'pio-004-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-005',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Range ces plans d\'eau du plus petit au plus grand par leur superficie.',
      explanationFr: 'L\'ordre des superficies est : lac Léman (environ 580 km²), '
          'lac Baïkal (31 722 km²), lac Victoria (68 870 km²), lac Supérieur '
          '(82 100 km²) puis mer Caspienne (environ 371 000 km²), considérée '
          'comme le plus grand lac du monde.',
      sourceReference: 'Encyclopaedia Britannica, articles de chaque plan d\'eau',
      factGroupId: 'fg-lake-areas',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-005-i1',
          label: 'Lac Léman',
          referenceValue: 580,
          unit: 'km²',
        ),
        OrderableItem(
          id: 'pio-005-i2',
          label: 'Lac Baïkal',
          referenceValue: 31722,
          unit: 'km²',
        ),
        OrderableItem(
          id: 'pio-005-i3',
          label: 'Lac Victoria',
          referenceValue: 68870,
          unit: 'km²',
        ),
        OrderableItem(
          id: 'pio-005-i4',
          label: 'Lac Supérieur',
          referenceValue: 82100,
          unit: 'km²',
        ),
        OrderableItem(
          id: 'pio-005-i5',
          label: 'Mer Caspienne',
          referenceValue: 371000,
          unit: 'km²',
        ),
      ],
      correctOrderIds: ['pio-005-i1', 'pio-005-i2', 'pio-005-i3', 'pio-005-i4', 'pio-005-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-006',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Range ces étapes de la conquête de l\'air et de l\'espace de la plus '
          'ancienne à la plus récente.',
      explanationFr: 'L\'ordre est : premier vol motorisé des frères Wright '
          '(1903), lancement de Spoutnik 1 (1957), premier vol spatial habité '
          '(1961), premier pas sur la Lune (1969) puis arrivée du premier '
          'équipage de la Station spatiale internationale (2000).',
      sourceReference: 'NASA, histoire de l\'aviation et des vols spatiaux habités',
      factGroupId: 'fg-aviation-space-milestones',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-006-i1',
          label: 'Premier vol motorisé des frères Wright',
          referenceValue: 1903,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-006-i2',
          label: 'Lancement de Spoutnik 1',
          referenceValue: 1957,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-006-i3',
          label: 'Premier vol spatial habité (Gagarine)',
          referenceValue: 1961,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-006-i4',
          label: 'Premier pas sur la Lune',
          referenceValue: 1969,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-006-i5',
          label: 'Premier équipage de la Station spatiale internationale',
          referenceValue: 2000,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-006-i1', 'pio-006-i2', 'pio-006-i3', 'pio-006-i4', 'pio-006-i5'],
    ),
  ];

  // ---------------------------------------------------------------------------
  // 5. How Much?
  // ---------------------------------------------------------------------------

  static final List<HowMuchQuestion> _howMuch = [
    HowMuchQuestion(
      id: 'hm-001',
      category: QuestionCategory.general,
      difficulty: Difficulty.easy,
      text: 'Combien de pays sont membres permanents du Conseil de sécurité de '
          'l\'ONU ?',
      explanationFr: 'Le Conseil de sécurité de l\'ONU compte cinq membres '
          'permanents dotés d\'un droit de veto : la Chine, les États-Unis, la '
          'France, le Royaume-Uni et la Russie.',
      sourceReference: 'Organisation des Nations unies, composition du Conseil de sécurité',
      factGroupId: 'fg-unsc-permanent',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 5,
        unit: 'pays',
        unitFr: 'pays',
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-002',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Combien de touches blanches possède un piano acoustique standard de '
          '88 touches ?',
      explanationFr: 'Un piano standard de 88 touches comprend 52 touches '
          'blanches et 36 touches noires, réparties sur un peu plus de sept octaves.',
      sourceReference: 'Encyclopaedia Britannica, article « Piano »',
      factGroupId: 'fg-piano-keys',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 52,
        unit: 'touches',
        unitFr: 'touches',
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-003',
      category: QuestionCategory.general,
      difficulty: Difficulty.medium,
      text: 'Combien de langues officielles l\'Organisation des Nations unies '
          'compte-t-elle ?',
      explanationFr: 'L\'ONU compte six langues officielles : l\'anglais, '
          'l\'arabe, le chinois, l\'espagnol, le français et le russe.',
      sourceReference: 'Organisation des Nations unies, langues officielles',
      factGroupId: 'fg-un-languages',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 6,
        unit: 'langues',
        unitFr: 'langues',
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-004',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'En quelle année le premier homme a-t-il marché sur la Lune ?',
      explanationFr: 'Neil Armstrong est sorti du module lunaire d\'Apollo 11 et '
          'a posé le pied sur la Lune le 20 juillet 1969.',
      sourceReference: 'NASA, mission Apollo 11',
      factGroupId: 'fg-moon-landing-1969',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1969,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1969,
        acceptedMax: 1969,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-005',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'En quelle année le mur de Berlin est-il tombé ?',
      explanationFr: 'Le mur de Berlin a été ouvert dans la nuit du 9 au '
          '10 novembre 1989, ce qui a conduit à la réunification allemande en 1990.',
      sourceReference: 'Encyclopaedia Britannica, article « Berlin Wall »',
      factGroupId: 'fg-berlin-wall-1989',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1989,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1989,
        acceptedMax: 1989,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-006',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Quelle est la distance approximative à vol d\'oiseau entre Paris et '
          'New York ?',
      explanationFr: 'La distance orthodromique entre Paris et New York est '
          'd\'environ 5 840 km, ce qui correspond à un vol transatlantique '
          'd\'environ sept heures.',
      sourceReference: 'IGN, calculs de distances orthodromiques',
      factGroupId: 'fg-paris-newyork-distance',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 5837,
        unit: 'km',
        unitFr: 'kilomètres',
        acceptedMin: 5500,
        acceptedMax: 6200,
        scoringRuleId: 'proximity_range',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-007',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Quelle est la population approximative de la France en 2024, en '
          'millions d\'habitants ?',
      explanationFr: 'La France comptait environ 68,4 millions d\'habitants au '
          '1er janvier 2024 selon l\'INSEE, métropole et outre-mer comprises.',
      sourceReference: 'INSEE, bilan démographique 2024',
      factGroupId: 'fg-france-population',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 68.4,
        unit: 'millions d\'habitants',
        unitFr: 'millions d\'habitants',
        acceptedMin: 66,
        acceptedMax: 70,
        scoringRuleId: 'proximity_range',
        significantFigures: 1,
      ),
    ),
  ];
}
