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

    // --- Batch 2 -------------------------------------------------------------

    WhichCameFirstQuestion(
      id: 'wcf-007',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la publication de la structure en '
          'double hélice de l\'ADN ou la naissance de la brebis Dolly ?',
      explanationFr: 'Watson et Crick ont publié la structure en double hélice '
          'de l\'ADN dans la revue Nature le 25 avril 1953. La brebis Dolly, '
          'premier mammifère cloné à partir d\'une cellule adulte, est née bien '
          'plus tard, le 5 juillet 1996, à l\'institut Roslin.',
      sourceReference: 'Nature, article de Watson et Crick (1953) ; '
          'Roslin Institute, dossier Dolly',
      factGroupId: 'fg-dna-helix-1953',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-007-e2',
          label: 'Naissance de la brebis Dolly, premier mammifère cloné',
          date: DateTime.utc(1996, 7, 5),
        ),
        ChronologyEvent(
          id: 'wcf-007-e1',
          label: 'Publication de la structure en double hélice de l\'ADN (Nature)',
          date: DateTime.utc(1953, 4, 25),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-008',
      category: QuestionCategory.history,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la déclaration d\'indépendance des '
          'États-Unis ou la prise de la Bastille ?',
      explanationFr: 'Le Congrès des États-Unis a adopté la Déclaration '
          'd\'indépendance le 4 juillet 1776, treize ans avant la prise de la '
          'Bastille du 14 juillet 1789, qui marque le début de la Révolution '
          'française.',
      sourceReference: 'Encyclopaedia Britannica, articles « Declaration of '
          'Independence » et « Storming of the Bastille »',
      factGroupId: 'fg-us-independence-1776',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-008-e2',
          label: 'Prise de la Bastille, début de la Révolution française',
          date: DateTime.utc(1789, 7, 14),
        ),
        ChronologyEvent(
          id: 'wcf-008-e1',
          label: 'Déclaration d\'indépendance des États-Unis',
          date: DateTime.utc(1776, 7, 4),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-009',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : le premier vol motorisé des frères '
          'Wright ou le début de la Première Guerre mondiale ?',
      explanationFr: 'Le Flyer des frères Wright a effectué son premier vol à '
          'Kitty Hawk le 17 décembre 1903, plus de dix ans avant le début de la '
          'Première Guerre mondiale, le 28 juillet 1914.',
      sourceReference: 'Smithsonian National Air and Space Museum ; '
          'Encyclopaedia Britannica, article « World War I »',
      factGroupId: 'fg-wright-flight-1903',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-009-e1',
          label: 'Premier vol motorisé des frères Wright',
          date: DateTime.utc(1903, 12, 17),
        ),
        ChronologyEvent(
          id: 'wcf-009-e2',
          label: 'Début de la Première Guerre mondiale',
          date: DateTime.utc(1914, 7, 28),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-010',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : le couronnement de Charlemagne comme '
          'empereur d\'Occident ou la signature de la Magna Carta ?',
      explanationFr: 'Charlemagne a été couronné empereur d\'Occident par le '
          'pape Léon III le 25 décembre 800. La Magna Carta anglaise, charte '
          'arrachée au roi Jean sans Terre, date de juin 1215.',
      sourceReference: 'Encyclopaedia Britannica, articles « Charlemagne » et '
          '« Magna Carta »',
      factGroupId: 'fg-charlemagne-800',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-010-e2',
          label: 'Signature de la Magna Carta en Angleterre',
          date: DateTime.utc(1215, 6, 15),
        ),
        ChronologyEvent(
          id: 'wcf-010-e1',
          label: 'Couronnement de Charlemagne, empereur d\'Occident',
          date: DateTime.utc(800, 12, 25),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-011',
      category: QuestionCategory.africa,
      difficulty: Difficulty.hard,
      text: 'Lequel est arrivé en premier : l\'indépendance du Ghana ou celle de '
          'l\'Algérie ?',
      explanationFr: 'Le Ghana, ancienne Côte-de-l\'Or britannique, est devenu '
          'indépendant le 6 mars 1957, sous la conduite de Kwame Nkrumah. '
          'L\'Algérie a proclamé son indépendance le 5 juillet 1962, après la '
          'guerre d\'Algérie.',
      sourceReference: 'Encyclopaedia Britannica, articles « Ghana » et '
          '« Algeria » ; Nations unies, liste des décolonisations',
      factGroupId: 'fg-ghana-independence-1957',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-011-e2',
          label: 'Indépendance de l\'Algérie',
          date: DateTime.utc(1962, 7, 5),
        ),
        ChronologyEvent(
          id: 'wcf-011-e1',
          label: 'Indépendance du Ghana',
          date: DateTime.utc(1957, 3, 6),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-012',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la découverte de la pénicilline par '
          'Fleming ou la première greffe de cœur humaine ?',
      explanationFr: 'Alexander Fleming a observé l\'action antibiotique de la '
          'pénicilline en septembre 1928. La première greffe de cœur humain, '
          'réalisée par Christiaan Barnard à Cape Town, date du 3 décembre 1967.',
      sourceReference: 'Nobel Prize, dossier Fleming ; Encyclopaedia '
          'Britannica, article « Heart transplant »',
      factGroupId: 'fg-penicillin-vs-hearttransplant-1928-1967',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-012-e1',
          label: 'Découverte de la pénicilline par Alexander Fleming',
          date: DateTime.utc(1928, 9, 1),
        ),
        ChronologyEvent(
          id: 'wcf-012-e2',
          label: 'Première greffe de cœur humaine (Christiaan Barnard)',
          date: DateTime.utc(1967, 12, 3),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-013',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Lequel est arrivé en premier : l\'inauguration du canal de Suez ou '
          'l\'achèvement du canal de Panama ?',
      explanationFr: 'Le canal de Suez, qui relie la Méditerranée à la mer '
          'Rouge, a été inauguré le 17 novembre 1869. Le canal de Panama a été '
          'ouvert à la navigation le 15 août 1914, après une reprise des '
          'travaux par les États-Unis.',
      sourceReference: 'Suez Canal Authority ; Autorité du canal de Panama, '
          'chronologie officielle',
      factGroupId: 'fg-suez-canal-1869',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-013-e2',
          label: 'Achèvement du canal de Panama',
          date: DateTime.utc(1914, 8, 15),
        ),
        ChronologyEvent(
          id: 'wcf-013-e1',
          label: 'Inauguration du canal de Suez',
          date: DateTime.utc(1869, 11, 17),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-014',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la création du parc de Yellowstone, '
          'premier parc national du monde, ou celle du parc de Banff au Canada ?',
      explanationFr: 'Le parc national de Yellowstone, aux États-Unis, a été '
          'créé par une loi du 1er mars 1872 et est généralement considéré comme '
          'le premier parc national. Le parc de Banff au Canada, né d\'une '
          'réserve de sources chaudes, date de 1885.',
      sourceReference: 'National Park Service, histoire de Yellowstone ; '
          'Parcs Canada, histoire de Banff',
      factGroupId: 'fg-yellowstone-1872',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-014-e2',
          label: 'Création du parc national de Banff (Canada)',
          date: DateTime.utc(1885, 11, 25),
        ),
        ChronologyEvent(
          id: 'wcf-014-e1',
          label: 'Création du parc national de Yellowstone (États-Unis)',
          date: DateTime.utc(1872, 3, 1),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-015',
      category: QuestionCategory.sports,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : la fondation du Comité international '
          'olympique ou le premier Tour de France ?',
      explanationFr: 'Le Comité international olympique a été fondé à Paris le '
          '23 juin 1894, à l\'initiative de Pierre de Coubertin. La première '
          'édition du Tour de France cycliste a eu lieu en 1903.',
      sourceReference: 'Comité international olympique, histoire du CIO ; '
          'Tour de France, archives',
      factGroupId: 'fg-ioc-foundation-1894',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-015-e2',
          label: 'Premier Tour de France',
          date: DateTime.utc(1903, 7, 1),
        ),
        ChronologyEvent(
          id: 'wcf-015-e1',
          label: 'Fondation du Comité international olympique',
          date: DateTime.utc(1894, 6, 23),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-016',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : la création de la neuvième symphonie '
          'de Beethoven ou celle du Sacre du printemps de Stravinsky ?',
      explanationFr: 'La neuvième symphonie de Beethoven, avec l\'Ode à la '
          'joie, a été créée à Vienne le 7 mai 1824. Le Sacre du printemps '
          'd\'Igor Stravinsky a été créé à Paris le 29 mai 1913, dans un '
          'concert resté célèbre pour son scandale.',
      sourceReference: 'Orchestre philharmonique de Vienne ; '
          'Encyclopaedia Britannica, article « The Rite of Spring »',
      factGroupId: 'fg-beethoven-ninth-1824',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-016-e1',
          label: 'Création de la neuvième symphonie de Beethoven',
          date: DateTime.utc(1824, 5, 7),
        ),
        ChronologyEvent(
          id: 'wcf-016-e2',
          label: 'Création du Sacre du printemps de Stravinsky (Paris)',
          date: DateTime.utc(1913, 5, 29),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-017',
      category: QuestionCategory.technology,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : le lancement du satellite Spoutnik 1 '
          'ou les premiers pas de l\'homme sur la Lune ?',
      explanationFr: 'Spoutnik 1, premier satellite artificiel de la Terre, a '
          'été lancé le 4 octobre 1957. Les premiers pas de Neil Armstrong sur '
          'la Lune ont eu lieu le 20 juillet 1969, lors de la mission Apollo 11.',
      sourceReference: 'NASA, dossiers Spoutnik et Apollo 11',
      factGroupId: 'fg-sputnik-apollo-1957-1969',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-017-e1',
          label: 'Lancement du satellite Spoutnik 1',
          date: DateTime.utc(1957, 10, 4),
        ),
        ChronologyEvent(
          id: 'wcf-017-e2',
          label: 'Premiers pas de l\'homme sur la Lune (Apollo 11)',
          date: DateTime.utc(1969, 7, 20),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-018',
      category: QuestionCategory.history,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : le début de la guerre de Cent Ans '
          'entre l\'Angleterre et la France ou l\'arrivée de la peste noire en '
          'Europe ?',
      explanationFr: 'La guerre de Cent Ans a débuté en 1337. La peste noire, '
          'partie d\'Asie centrale, a atteint l\'Europe par la mer Noire en '
          '1347 et s\'y est propagée jusqu\'en 1353.',
      sourceReference: 'Encyclopaedia Britannica, articles « Hundred Years\' '
          'War » et « Black Death »',
      factGroupId: 'fg-hundred-years-war-1337',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-018-e1',
          label: 'Début de la guerre de Cent Ans',
          date: DateTime.utc(1337, 5, 24),
        ),
        ChronologyEvent(
          id: 'wcf-018-e2',
          label: 'Arrivée de la peste noire en Europe',
          date: DateTime.utc(1347, 10, 1),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-019',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Lequel est arrivé en premier : le premier homme dans l\'espace ou la '
          'première sortie dans l\'espace ?',
      explanationFr: 'Youri Gagarine est devenu le premier homme dans l\'espace '
          'le 12 avril 1961 à bord de Vostok 1. La première sortie extravéhiculaire '
          'a été effectuée par Alexeï Leonov le 18 mars 1965, depuis Voskhod 2.',
      sourceReference: 'NASA, dossiers Vostok 1 et Voskhod 2 ; '
          'Encyclopaedia Britannica, article « Spacewalk »',
      factGroupId: 'fg-gagarin-1961',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-019-e2',
          label: 'Première sortie dans l\'espace (Alexeï Leonov)',
          date: DateTime.utc(1965, 3, 18),
        ),
        ChronologyEvent(
          id: 'wcf-019-e1',
          label: 'Premier homme dans l\'espace (Youri Gagarine)',
          date: DateTime.utc(1961, 4, 12),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-020',
      category: QuestionCategory.nature,
      difficulty: Difficulty.easy,
      text: 'Lequel est arrivé en premier : l\'éruption du Krakatoa en Indonésie '
          'ou celle du mont Saint Helens aux États-Unis ?',
      explanationFr: 'Le Krakatoa est entré en éruption les 26 et 27 août 1883, '
          'avec une explosion entendue à des milliers de kilomètres. Le mont '
          'Saint Helens, dans l\'État de Washington, est entré en éruption le '
          '18 mai 1980.',
      sourceReference: 'Smithsonian Institution, Global Volcanism Program',
      factGroupId: 'fg-krakatoa-1883',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-020-e2',
          label: 'Éruption du mont Saint Helens (États-Unis)',
          date: DateTime.utc(1980, 5, 18),
        ),
        ChronologyEvent(
          id: 'wcf-020-e1',
          label: 'Éruption du Krakatoa (Indonésie)',
          date: DateTime.utc(1883, 8, 27),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-021',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Lequel est arrivé en premier : l\'abolition de l\'esclavage dans '
          'l\'Empire britannique ou aux États-Unis ?',
      explanationFr: 'Le Slavery Abolition Act britannique a été adopté le 28 '
          'août 1833 et est entré en vigueur le 1er août 1834. Aux États-Unis, '
          'le treizième amendement abolissant l\'esclavage a été ratifié le 6 '
          'décembre 1865, après la guerre de Sécession.',
      sourceReference: 'The National Archives (Royaume-Uni) ; '
          'Archives nationales des États-Unis, Constitution',
      factGroupId: 'fg-uk-slavery-abolition-1833',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-021-e1',
          label: 'Slavery Abolition Act dans l\'Empire britannique',
          date: DateTime.utc(1833, 8, 28),
        ),
        ChronologyEvent(
          id: 'wcf-021-e2',
          label: 'Treizième amendement abolissant l\'esclavage aux États-Unis',
          date: DateTime.utc(1865, 12, 6),
        ),
      ],
      correctFirstIndex: 0,
      correctSecondIndex: 1,
    ),
    WhichCameFirstQuestion(
      id: 'wcf-022',
      category: QuestionCategory.technology,
      difficulty: Difficulty.hard,
      text: 'Lequel est arrivé en premier : la première connexion établie sur le '
          'réseau ARPANET ou l\'envoi du premier courriel entre deux machines '
          'distinctes ?',
      explanationFr: 'La première liaison d\'ARPANET, réseau ancêtre de '
          'l\'internet, a été établie entre l\'UCLA et le Stanford Research '
          'Institute le 29 octobre 1969. Ray Tomlinson a envoyé le premier '
          'courriel entre deux machines distinctes en 1971.',
      sourceReference: 'Internet Society, chronologie d\'ARPANET ; '
          'Smithsonian Institution, dossier Ray Tomlinson',
      factGroupId: 'fg-arpanet-1969',
      createdAt: _createdAt,
      events: [
        ChronologyEvent(
          id: 'wcf-022-e2',
          label: 'Premier courriel entre deux machines distinctes (1971)',
          date: DateTime.utc(1971, 1, 1),
        ),
        ChronologyEvent(
          id: 'wcf-022-e1',
          label: 'Première connexion sur le réseau ARPANET',
          date: DateTime.utc(1969, 10, 29),
        ),
      ],
      correctFirstIndex: 1,
      correctSecondIndex: 0,
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

    // --- Batch 2 -------------------------------------------------------------

    GuessTheCountryQuestion(
      id: 'gtc-007',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays d\'Afrique de l\'Ouest à partir des indices.',
      explanationFr: 'Le Nigeria est le pays le plus peuplé d\'Afrique, avec '
          'plus de 200 millions d\'habitants. Sa capitale est Abuja, mais Lagos '
          'reste la plus grande ville, et son industrie cinématographique, '
          'surnommée Nollywood, est l\'une des plus productives au monde.',
      sourceReference: 'Encyclopaedia Britannica, article « Nigeria » ; '
          'Banque mondiale, données démographiques',
      factGroupId: 'fg-country-nigeria',
      createdAt: _createdAt,
      targetCountry: 'Nigeria',
      targetCountryCode: 'NG',
      acceptedAnswers: ['Nigeria', 'Nigéria', 'nigeria'],
      capital: 'Abuja',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'C\'est le pays le plus peuplé d\'Afrique.', order: 1),
        CountryClue(text: 'Sa capitale est Abuja, mais Lagos est sa plus grande ville.', order: 2),
        CountryClue(text: 'On y parle plus de 500 langues.', order: 3),
        CountryClue(text: 'Son cinéma est surnommé Nollywood.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-008',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays d\'Afrique australe à partir des indices.',
      explanationFr: 'L\'Afrique du Sud possède trois capitales : '
          'Pretoria (administrative), Le Cap (législative) et Bloemfontein '
          '(judiciaire). L\'apartheid y a pris fin avec les premières élections '
          'multiraciales de 1994, qui ont porté Nelson Mandela à la présidence.',
      sourceReference: 'Encyclopaedia Britannica, article « South Africa »',
      factGroupId: 'fg-country-southafrica',
      createdAt: _createdAt,
      targetCountry: 'Afrique du Sud',
      targetCountryCode: 'ZA',
      acceptedAnswers: ['Afrique du Sud', 'afrique du sud', 'South Africa'],
      capital: 'Pretoria',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'Il possède trois capitales.', order: 1),
        CountryClue(text: 'Nelson Mandela y est devenu président en 1994.', order: 2),
        CountryClue(text: 'La montagne de la Table surplombe l\'une de ses villes.', order: 3),
        CountryClue(text: 'Le cap de Bonne-Espérance se trouve sur ses côtes.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-009',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays du Maghreb à partir des indices.',
      explanationFr: 'Le Maroc est un royaume situé au nord-ouest de '
          'l\'Afrique, dont la capitale est Rabat. Le détroit de Gibraltar le '
          'sépare de l\'Espagne, et le massif de l\'Atlas traverse le pays du '
          'sud-ouest au nord-est.',
      sourceReference: 'Encyclopaedia Britannica, article « Morocco »',
      factGroupId: 'fg-country-morocco',
      createdAt: _createdAt,
      targetCountry: 'Maroc',
      targetCountryCode: 'MA',
      acceptedAnswers: ['Maroc', 'maroc', 'Morocco'],
      capital: 'Rabat',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'C\'est un royaume du nord-ouest de l\'Afrique.', order: 1),
        CountryClue(text: 'Le détroit de Gibraltar le sépare de l\'Espagne.', order: 2),
        CountryClue(text: 'Sa capitale est Rabat.', order: 3),
        CountryClue(text: 'Le massif de l\'Atlas le traverse.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-010',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays africain où siège l\'Union africaine à partir des indices.',
      explanationFr: 'L\'Éthiopie a pour capitale Addis-Abeba, siège de '
          'l\'Union africaine. C\'est le berceau du café, le pays utilise son '
          'propre calendrier, et son alphabet, le guèze, est encore en usage.',
      sourceReference: 'Encyclopaedia Britannica, article « Ethiopia » ; '
          'Union africaine, siège d\'Addis-Abeba',
      factGroupId: 'fg-country-ethiopia',
      createdAt: _createdAt,
      targetCountry: 'Éthiopie',
      targetCountryCode: 'ET',
      acceptedAnswers: ['Éthiopie', 'Ethiopie', 'Ethiopia', 'ethiopie'],
      capital: 'Addis-Abeba',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'L\'Union africaine a son siège dans sa capitale.', order: 1),
        CountryClue(text: 'Il est considéré comme le berceau du café.', order: 2),
        CountryClue(text: 'Son écriture traditionnelle est l\'alphabet guèze.', order: 3),
        CountryClue(text: 'Sa capitale est Addis-Abeba.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-011',
      category: QuestionCategory.africa,
      difficulty: Difficulty.hard,
      text: 'Devine ce pays dont la capitale est à la pointe ouest de l\'Afrique.',
      explanationFr: 'Le Sénégal a pour capitale Dakar, située sur la '
          'presqu\'île la plus occidentale de l\'Afrique continentale. L\'île de '
          'Gorée, au large de Dakar, est inscrite au patrimoine mondial de '
          'l\'UNESCO, et le lac Retba, rose, se trouve au nord du pays.',
      sourceReference: 'Encyclopaedia Britannica, article « Senegal » ; '
          'UNESCO, Île de Gorée',
      factGroupId: 'fg-country-senegal',
      createdAt: _createdAt,
      targetCountry: 'Sénégal',
      targetCountryCode: 'SN',
      acceptedAnswers: ['Sénégal', 'Senegal', 'senegal'],
      capital: 'Dakar',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'Sa capitale occupe la pointe la plus occidentale de l\'Afrique continentale.', order: 1),
        CountryClue(text: 'L\'île de Gorée se trouve au large de sa capitale.', order: 2),
        CountryClue(text: 'Le lac Retba, rose, se trouve sur son territoire.', order: 3),
        CountryClue(text: 'Sa capitale est Dakar.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-012',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Devine le pays du Kilimandjaro et du Serengeti à partir des indices.',
      explanationFr: 'La Tanzanie abrite le Kilimandjaro, plus haut sommet '
          'd\'Afrique, et le parc du Serengeti, théâtre de la grande migration '
          'des gnous. Sa capitale est Dodoma, tandis que Dar es Salam reste sa '
          'plus grande ville, et l\'archipel de Zanzibar borde ses côtes.',
      sourceReference: 'Encyclopaedia Britannica, articles « Tanzania » et '
          '« Serengeti National Park »',
      factGroupId: 'fg-country-tanzania',
      createdAt: _createdAt,
      targetCountry: 'Tanzanie',
      targetCountryCode: 'TZ',
      acceptedAnswers: ['Tanzanie', 'tanzanie', 'Tanzania'],
      capital: 'Dodoma',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'Le plus haut sommet d\'Afrique s\'y trouve.', order: 1),
        CountryClue(text: 'Le parc du Serengeti et sa grande migration s\'y trouvent.', order: 2),
        CountryClue(text: 'Sa capitale politique est Dodoma.', order: 3),
        CountryClue(text: 'L\'archipel de Zanzibar borde ses côtes.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-013',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays d\'Europe du Sud dont le drapeau cache deux enclaves.',
      explanationFr: 'L\'Italie forme une péninsule en forme de botte qui '
          'avance en Méditerranée. Les deux plus petits États du monde, le '
          'Vatican et Saint-Marin, sont enclavés sur son territoire, et sa '
          'capitale est Rome.',
      sourceReference: 'Encyclopaedia Britannica, article « Italy »',
      factGroupId: 'fg-country-italy',
      createdAt: _createdAt,
      targetCountry: 'Italie',
      targetCountryCode: 'IT',
      acceptedAnswers: ['Italie', 'italie', 'Italy'],
      capital: 'Rome',
      continent: 'Europe',
      clues: [
        CountryClue(text: 'Sa forme évoque une botte en Méditerranée.', order: 1),
        CountryClue(text: 'Le Vatican et Saint-Marin sont enclavés sur son territoire.', order: 2),
        CountryClue(text: 'Sa capitale est Rome.', order: 3),
        CountryClue(text: 'La tour de Pise s\'y trouve.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-014',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays d\'Asie du Sud à partir des indices.',
      explanationFr: 'L\'Inde est le pays le plus peuplé du monde depuis 2023. '
          'Sa capitale est New Delhi, le Taj Mahal se trouve à Agra et le '
          'tigre du Bengale est son animal emblématique.',
      sourceReference: 'Nations unies, World Population Prospects ; '
          'Encyclopaedia Britannica, article « India »',
      factGroupId: 'fg-country-india',
      createdAt: _createdAt,
      targetCountry: 'Inde',
      targetCountryCode: 'IN',
      acceptedAnswers: ['Inde', 'inde', 'India'],
      capital: 'New Delhi',
      continent: 'Asie',
      clues: [
        CountryClue(text: 'C\'est le pays le plus peuplé du monde.', order: 1),
        CountryClue(text: 'Sa capitale est New Delhi.', order: 2),
        CountryClue(text: 'Le Taj Mahal s\'y trouve, à Agra.', order: 3),
        CountryClue(text: 'Le tigre du Bengale en est l\'animal emblématique.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-015',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Devine ce pays andin et pacifique d\'Amérique du Sud à partir des indices.',
      explanationFr: 'Le Pérou est bordé par le Pacifique et partage avec la '
          'Bolivie le lac Titicaca, le plus haut lac navigable du monde. Le site '
          'inca du Machu Picchu se trouve près de Cuzco, et sa capitale est Lima.',
      sourceReference: 'Encyclopaedia Britannica, articles « Peru » et '
          '« Lake Titicaca »',
      factGroupId: 'fg-country-peru',
      createdAt: _createdAt,
      targetCountry: 'Pérou',
      targetCountryCode: 'PE',
      acceptedAnswers: ['Pérou', 'Perou', 'Peru'],
      capital: 'Lima',
      continent: 'Amérique du Sud',
      clues: [
        CountryClue(text: 'Il partage avec la Bolivie le lac Titicaca.', order: 1),
        CountryClue(text: 'Le Machu Picchu, cité inca, s\'y trouve.', order: 2),
        CountryClue(text: 'Sa capitale est Lima, sur la côte pacifique.', order: 3),
        CountryClue(text: 'L\'une des lignes de Nazca s\'y trouve sur son désert.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-016',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays d\'Europe du Nord à partir des indices.',
      explanationFr: 'La Norvège est célèbre pour ses fjords, ses aurores '
          'boréales et son littoral découpé. Sa capitale est Oslo, et '
          'l\'archipel du Svalbard, dans l\'Arctique, fait partie de son '
          'territoire.',
      sourceReference: 'Encyclopaedia Britannica, article « Norway »',
      factGroupId: 'fg-country-norway',
      createdAt: _createdAt,
      targetCountry: 'Norvège',
      targetCountryCode: 'NO',
      acceptedAnswers: ['Norvège', 'Norvege', 'norvege'],
      capital: 'Oslo',
      continent: 'Europe',
      clues: [
        CountryClue(text: 'Ce pays est connu pour ses fjords.', order: 1),
        CountryClue(text: 'Les aurores boréales y sont fréquentes en hiver.', order: 2),
        CountryClue(text: 'Sa capitale est Oslo.', order: 3),
        CountryClue(text: 'L\'archipel arctique du Svalbard lui appartient.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-017',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays de la péninsule coréenne à partir des indices.',
      explanationFr: 'La Corée du Sud occupe la moitié sud de la péninsule '
          'coréenne, séparée du Nord par une zone démilitarisée depuis 1953. Sa '
          'capitale est Séoul, son écriture est le hangeul et la fermentation du '
          'chou, le kimchi, est un symbole national.',
      sourceReference: 'Encyclopaedia Britannica, article « South Korea »',
      factGroupId: 'fg-country-southkorea',
      createdAt: _createdAt,
      targetCountry: 'Corée du Sud',
      targetCountryCode: 'KR',
      acceptedAnswers: ['Corée du Sud', 'coree du sud', 'South Korea'],
      capital: 'Séoul',
      continent: 'Asie',
      clues: [
        CountryClue(text: 'Elle occupe la moitié sud d\'une péninsule.', order: 1),
        CountryClue(text: 'Une zone démilitarisée la sépare de son voisin du Nord.', order: 2),
        CountryClue(text: 'Sa capitale est Séoul.', order: 3),
        CountryClue(text: 'Son alphabet national s\'appelle le hangeul.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-018',
      category: QuestionCategory.africa,
      difficulty: Difficulty.hard,
      text: 'Devine ce pays enclavé d\'Afrique de l\'Ouest à partir des indices.',
      explanationFr: 'Le Mali est un pays enclavé d\'Afrique de l\'Ouest dont '
          'la capitale est Bamako. Le fleuve Niger y décrit un large coude '
          'intérieur, le fleuve Sénégal borde l\'ouest du pays, et la grande '
          'mosquée de terre de Djenné, la plus grande construction en terre '
          'crue du monde, est inscrite au patrimoine mondial.',
      sourceReference: 'UNESCO, grande mosquée de Djenné ; '
          'Encyclopaedia Britannica, article « Mali »',
      factGroupId: 'fg-country-mali',
      createdAt: _createdAt,
      targetCountry: 'Mali',
      targetCountryCode: 'ML',
      acceptedAnswers: ['Mali', 'mali'],
      capital: 'Bamako',
      continent: 'Afrique',
      clues: [
        CountryClue(text: 'C\'est un pays enclavé d\'Afrique de l\'Ouest.', order: 1),
        CountryClue(text: 'Le fleuve Niger y décrit un grand coude.', order: 2),
        CountryClue(text: 'La grande mosquée de terre de Djenné s\'y trouve.', order: 3),
        CountryClue(text: 'Sa capitale est Bamako.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-019',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Devine ce pays hispanophone d\'Amérique du Nord à partir des indices.',
      explanationFr: 'Le Mexique est bordé par le golfe du Mexique et le '
          'Pacifique, et la péninsule du Yucatán s\'avance dans la mer des '
          'Caraïbes. Sa capitale, Mexico, est bâtie sur l\'ancien lac de '
          'Texcoco, et les cénotes y sont fréquents.',
      sourceReference: 'Encyclopaedia Britannica, article « Mexico »',
      factGroupId: 'fg-country-mexico',
      createdAt: _createdAt,
      targetCountry: 'Mexique',
      targetCountryCode: 'MX',
      acceptedAnswers: ['Mexique', 'mexique', 'Mexico'],
      capital: 'Mexico',
      continent: 'Amérique du Nord',
      clues: [
        CountryClue(text: 'La péninsule du Yucatán s\'avance dans la mer des Caraïbes.', order: 1),
        CountryClue(text: 'Des puits naturels appelés cénotes s\'y trouvent.', order: 2),
        CountryClue(text: 'Sa capitale est bâtie sur un ancien lac.', order: 3),
        CountryClue(text: 'Il est bordé au sud-est par le Guatemala et le Belize.', order: 4),
      ],
    ),
    GuessTheCountryQuestion(
      id: 'gtc-020',
      category: QuestionCategory.geography,
      difficulty: Difficulty.easy,
      text: 'Devine ce pays d\'Océanie à partir des indices.',
      explanationFr: 'La Nouvelle-Zélande est formée de deux îles principales '
          'dans le Pacifique sud. Sa capitale est Wellington, son nom maori est '
          'Aotearoa et le kiwi, un oiseau incapable de voler, en est '
          'l\'emblème.',
      sourceReference: 'Encyclopaedia Britannica, article « New Zealand » ; '
          'Te Puni Kōkiri, ministère du Développement maori',
      factGroupId: 'fg-country-newzealand',
      createdAt: _createdAt,
      targetCountry: 'Nouvelle-Zélande',
      targetCountryCode: 'NZ',
      acceptedAnswers: ['Nouvelle-Zélande', 'nouvelle-zélande', 'New Zealand'],
      capital: 'Wellington',
      continent: 'Océanie',
      clues: [
        CountryClue(text: 'Il est formé de deux îles principales.', order: 1),
        CountryClue(text: 'Son nom maori est Aotearoa.', order: 2),
        CountryClue(text: 'Sa capitale est Wellington.', order: 3),
        CountryClue(text: 'Le kiwi, oiseau qui ne vole pas, en est l\'emblème.', order: 4),
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

    // --- Batch 2 -------------------------------------------------------------

    FactOrCapQuestion(
      id: 'foc-008',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Fait ou fake : la lumière du Soleil met environ huit minutes pour '
          'atteindre la Terre.',
      explanationFr: 'La distance moyenne Terre-Soleil est d\'environ 150 '
          'millions de kilomètres. À la vitesse de la lumière, soit près de '
          '300 000 km/s, le trajet dure environ 8 minutes et 20 secondes.',
      sourceReference: 'NASA, fiche sur la vitesse de la lumière et les '
          'distances du Système solaire',
      factGroupId: 'fg-light-travel-time',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-008-s1',
          text: 'La lumière du Soleil met environ huit minutes pour atteindre la Terre.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-009',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : le grand dauphin est un poisson.',
      explanationFr: 'Le dauphin est un mammifère marin : il respire par des '
          'poumons, allaite ses petits et possède des poils à l\'état embryonnaire. '
          'Il n\'est donc pas un poisson, contrairement à ce que sa silhouette '
          'pourrait laisser croire.',
      sourceReference: 'Encyclopaedia Britannica, article « Dolphin »',
      factGroupId: 'fg-dolphin-mammal',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-009-s1',
          text: 'Le grand dauphin est un poisson.',
          isTrue: false,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-010',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : le lac Victoria est bordé par la Tanzanie, l\'Ouganda '
          'et le Kenya.',
      explanationFr: 'Le lac Victoria, plus grand lac d\'Afrique, est bien '
          'partagé entre ces trois pays. C\'est la source du Nil Blanc, qui '
          'quitte le lac à Jinja, en Ouganda.',
      sourceReference: 'Encyclopaedia Britannica, article « Lake Victoria » ; '
          'UNESCO, programme du lac Victoria',
      factGroupId: 'fg-lake-victoria-borders',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-010-s1',
          text: 'Le lac Victoria est bordé par la Tanzanie, l\'Ouganda et le Kenya.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-011',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'Fait ou fake : le Kilimandjaro est le plus haut sommet d\'Afrique.',
      explanationFr: 'Le Kilimandjaro, en Tanzanie, culmine à 5 895 mètres et '
          'est le plus haut sommet d\'Afrique ainsi que le point culminant '
          'isolé le plus élevé du monde.',
      sourceReference: 'UNESCO, parc national du Kilimandjaro ; '
          'Encyclopaedia Britannica, article « Kilimanjaro »',
      factGroupId: 'fg-kilimanjaro-highest',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-011-s1',
          text: 'Le Kilimandjaro est le plus haut sommet d\'Afrique.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-012',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : la Grande Barrière de corail se trouve au large des '
          'côtes du Kenya.',
      explanationFr: 'La Grande Barrière de corail borde la côte nord-est de '
          'l\'Australie, dans la mer de Corail. Le Kenya possède des récifs '
          'coralliens, notamment à Watamu, mais bien plus petits.',
      sourceReference: 'UNESCO, Grande Barrière de corail ; '
          'Encyclopaedia Britannica, article « Great Barrier Reef »',
      factGroupId: 'fg-great-barrier-reef-location',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-012-s1',
          text: 'La Grande Barrière de corail se trouve au large des côtes du Kenya.',
          isTrue: false,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-013',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'Deux vérités et un mensonge sur l\'Afrique : identifie le mensonge.',
      explanationFr: 'Le fleuve Niger prend bien sa source en Guinée, dans les '
          'hauts plateaux du Fouta-Djalon, et Zanzibar appartient bien à la '
          'Tanzanie. En revanche le Sahara couvre une grande partie de l\'Afrique '
          'du Nord, de la Mauritanie à l\'Égypte, et pas seulement l\'Égypte.',
      sourceReference: 'Encyclopaedia Britannica, articles « Niger River », '
          '« Zanzibar » et « Sahara »',
      factGroupId: 'fg-africa-geography-mix',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-013-s1',
          text: 'Le fleuve Niger prend sa source en Guinée.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-013-s2',
          text: 'L\'archipel de Zanzibar appartient à la Tanzanie.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-013-s3',
          text: 'Le Sahara s\'étend uniquement en Égypte.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-014',
      category: QuestionCategory.history,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : la Première Guerre mondiale a commencé en 1914.',
      explanationFr: 'L\'Autriche-Hongrie a déclaré la guerre à la Serbie le '
          '28 juillet 1914, ce qui a entraîné les autres puissances européennes '
          'dans le conflit jusqu\'en 1918.',
      sourceReference: 'Encyclopaedia Britannica, article « World War I »',
      factGroupId: 'fg-wwi-start-1914',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-014-s1',
          text: 'La Première Guerre mondiale a commencé en 1914.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-015',
      category: QuestionCategory.history,
      difficulty: Difficulty.hard,
      text: 'Fait ou fake : l\'Empire romain d\'Occident a pris fin en 476.',
      explanationFr: 'En 476, le chef germanique Odoacre dépose le dernier '
          'empereur d\'Occident, Romulus Augustule, et envoie les insignes '
          'impériaux à Constantinople. Cette date marque traditionnellement la '
          'fin de l\'Empire romain d\'Occident.',
      sourceReference: 'Encyclopaedia Britannica, articles « Romulus '
          'Augustulus » et « Odoacer »',
      factGroupId: 'fg-western-rome-end-476',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-015-s1',
          text: 'L\'Empire romain d\'Occident a pris fin en 476.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-016',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : le premier iPhone est sorti en 2007.',
      explanationFr: 'Steve Jobs a présenté le premier iPhone le 9 janvier '
          '2007, et l\'appareil est mis en vente aux États-Unis le 29 juin 2007. '
          'Il ne disposait alors ni de l\'App Store ni de la 3G.',
      sourceReference: 'Apple, communiqué de presse de 2007',
      factGroupId: 'fg-iphone-2007',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-016-s1',
          text: 'Le premier iPhone est sorti en 2007.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-017',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Deux vérités et un mensonge sur les animaux : identifie le mensonge.',
      explanationFr: 'Le panda mange effectivement presque exclusivement du '
          'bambou, et le colibri est bien le seul oiseau capable de voler en '
          'arrière et vers le haut. En revanche les chauves-souris sont des '
          'mammifères volants, pas des oiseaux.',
      sourceReference: 'Encyclopaedia Britannica, articles « Giant panda » et '
          '« Hummingbird » ; Smithsonian Institution, chauves-souris',
      factGroupId: 'fg-animal-traits-mix',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-017-s1',
          text: 'Le panda se nourrit principalement de bambou.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-017-s2',
          text: 'Le colibri est le seul oiseau capable de voler en arrière.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-017-s3',
          text: 'Les chauves-souris sont des oiseaux.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-018',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Fait ou fake : l\'eau pure bout à 100 °C au niveau de la mer.',
      explanationFr: 'À la pression atmosphérique normale de 1 013 hPa, soit '
          'le niveau de la mer, l\'eau pure bout à 100 °C. La température '
          'd\'ébullition diminue avec l\'altitude, ce qui rend la cuisson des '
          'aliments plus difficile en montagne.',
      sourceReference: 'Organisation météorologique mondiale, propriétés de '
          'l\'eau ; Encyclopaedia Britannica, article « Boiling point »',
      factGroupId: 'fg-water-boiling-point',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-018-s1',
          text: 'L\'eau pure bout à 100 °C au niveau de la mer.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-019',
      category: QuestionCategory.africa,
      difficulty: Difficulty.hard,
      text: 'Fait ou fake : l\'Empire du Mali avait pour capitale la ville de Gao.',
      explanationFr: 'Gao a été la capitale de l\'Empire songhaï, à partir du '
          'XVe siècle. La capitale de l\'Empire du Mali, qui atteint son apogée '
          'sous Mansa Moussa au XIVe siècle, est généralement située à Niani, '
          'près de la frontière actuelle avec la Guinée.',
      sourceReference: 'UNESCO, dossier Tombouctou ; Encyclopaedia Britannica, '
          'articles « Mali empire » et « Songhai empire »',
      factGroupId: 'fg-mali-empire-capital',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-019-s1',
          text: 'L\'Empire du Mali avait pour capitale la ville de Gao.',
          isTrue: false,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-020',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : la Joconde est exposée au musée du Louvre, à Paris.',
      explanationFr: 'La Joconde, peinte par Léonard de Vinci entre 1503 et '
          '1519, est bien conservée au musée du Louvre à Paris, où elle est '
          'exposée derrière un vitrage pare-balles.',
      sourceReference: 'Musée du Louvre, collection des peintures',
      factGroupId: 'fg-mona-lisa-louvre',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-020-s1',
          text: 'La Joconde est exposée au musée du Louvre, à Paris.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-021',
      category: QuestionCategory.sports,
      difficulty: Difficulty.easy,
      text: 'Fait ou fake : une équipe de football aligne onze joueurs sur le '
          'terrain.',
      explanationFr: 'Une équipe de football compte onze joueurs, dont le '
          'gardien de but. Jouer à moins de sept joueurs met fin au match selon '
          'les Lois du jeu de l\'IFAB.',
      sourceReference: 'IFAB, Lois du jeu de la FIFA',
      factGroupId: 'fg-football-eleven',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-021-s1',
          text: 'Une équipe de football aligne onze joueurs sur le terrain.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-022',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Deux vérités et un mensonge sur la géographie : identifie le mensonge.',
      explanationFr: 'Le détroit de Gibraltar sépare bien l\'Espagne du Maroc, '
          'et le lac Baïkal, en Sibérie, est bien le lac le plus profond du '
          'monde avec ses 1 642 mètres. En revanche le mont Blanc, point '
          'culminant de l\'Europe occidentale, se trouve dans les Alpes, pas en '
          'Afrique.',
      sourceReference: 'Encyclopaedia Britannica, articles « Strait of '
          'Gibraltar » et « Lake Baikal »',
      factGroupId: 'fg-geography-records-mix',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-022-s1',
          text: 'Le détroit de Gibraltar sépare l\'Espagne du Maroc.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-022-s2',
          text: 'Le lac Baïkal est le lac le plus profond du monde.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-022-s3',
          text: 'Le mont Blanc est le plus haut sommet d\'Afrique.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-023',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Fait ou fake : la vallée du Grand Rift traverse l\'Afrique de l\'Est.',
      explanationFr: 'La vallée du Grand Rift s\'étend du Moyen-Orient jusqu\'au '
          'Mozambique, en traversant l\'Éthiopie, le Kenya, la Tanzanie et '
          'l\'Ouganda. Elle est le théâtre d\'importantes découvertes '
          'paléontologiques et d\'une activité volcanique notable.',
      sourceReference: 'UNESCO, sites de la vallée du Grand Rift ; '
          'Encyclopaedia Britannica, article « Great Rift Valley »',
      factGroupId: 'fg-great-rift-valley',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-023-s1',
          text: 'La vallée du Grand Rift traverse l\'Afrique de l\'Est.',
          isTrue: true,
        ),
      ],
    ),
    FactOrCapQuestion(
      id: 'foc-024',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Deux vérités et un mensonge sur l\'atmosphère : identifie le mensonge.',
      explanationFr: 'Le son se propage effectivement plus vite dans l\'eau que '
          'dans l\'air, et le tonnerre est bien causé par la dilatation '
          'violente de l\'air chauffé par la foudre. En revanche la foudre peut '
          'frapper plusieurs fois le même point, comme l\'a montré l\'Empire '
          'State Building de New York une vingtaine de fois par an.',
      sourceReference: 'Encyclopaedia Britannica, articles « Lightning » et '
          '« Thunder » ; Empire State Realty Trust, foudre sur l\'Empire State Building',
      factGroupId: 'fg-atmospheric-mix',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-024-s1',
          text: 'Le son se propage plus vite dans l\'eau que dans l\'air.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-024-s2',
          text: 'Le tonnerre est produit par la dilatation violente de l\'air chauffé par la foudre.',
          isTrue: true,
        ),
        FactStatement(
          id: 'foc-024-s3',
          text: 'La foudre ne frappe jamais deux fois au même endroit.',
          isTrue: false,
        ),
      ],
      lieStatementIndex: 2,
    ),
    FactOrCapQuestion(
      id: 'foc-025',
      category: QuestionCategory.technology,
      difficulty: Difficulty.hard,
      text: 'Fait ou fake : Alan Turing a décrit en 1936 un modèle de calcul '
          'appelé machine de Turing.',
      explanationFr: 'Dans son article de 1936, « On Computable Numbers », '
          'Alan Turing présente un modèle abstrait de machine capable '
          'd\'effectuer tout calcul, connu aujourd\'hui sous le nom de machine '
          'de Turing, fondement théorique de l\'informatique.',
      sourceReference: 'Proceedings of the London Mathematical Society, '
          'article de Turing (1936)',
      factGroupId: 'fg-turing-machine-1936',
      createdAt: _createdAt,
      statements: [
        FactStatement(
          id: 'foc-025-s1',
          text: 'Alan Turing a décrit en 1936 un modèle de calcul appelé machine de Turing.',
          isTrue: true,
        ),
      ],
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

    // --- Batch 2 -------------------------------------------------------------

    PutInOrderQuestion(
      id: 'pio-007',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Range ces étapes de l\'informatique personnelle de la plus ancienne '
          'à la plus récente.',
      explanationFr: 'L\'ordre est : l\'Apple I (1976), l\'IBM PC (1981), '
          'Windows 1.0 (1985), l\'ouverture du Web au public par le CERN (1991) '
          'puis l\'iPhone (2007).',
      sourceReference: 'Apple, chronologie des produits ; IBM, histoire du '
          'premier PC ; Microsoft, historique de Windows ; CERN, naissance du Web',
      factGroupId: 'fg-personal-computing-timeline',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-007-i1',
          label: 'Commercialisation de l\'Apple I',
          referenceValue: 1976,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-007-i2',
          label: 'Sortie de l\'IBM PC',
          referenceValue: 1981,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-007-i3',
          label: 'Sortie de Windows 1.0',
          referenceValue: 1985,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-007-i4',
          label: 'Ouverture du Web au public (CERN)',
          referenceValue: 1991,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-007-i5',
          label: 'Sortie du premier iPhone',
          referenceValue: 2007,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-007-i1', 'pio-007-i2', 'pio-007-i3', 'pio-007-i4', 'pio-007-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-008',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Range ces indépendances africaines de la plus ancienne à la plus récente.',
      explanationFr: 'L\'ordre est : le Ghana en 1957, le Nigeria en 1960, '
          'l\'Algérie en 1962, le Kenya en 1963 et la Namibie en 1990.',
      sourceReference: 'Nations unies, chronologie de la décolonisation',
      factGroupId: 'fg-african-independence-timeline',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-008-i1',
          label: 'Indépendance du Ghana',
          referenceValue: 1957,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-008-i2',
          label: 'Indépendance du Nigeria',
          referenceValue: 1960,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-008-i3',
          label: 'Indépendance de l\'Algérie',
          referenceValue: 1962,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-008-i4',
          label: 'Indépendance du Kenya',
          referenceValue: 1963,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-008-i5',
          label: 'Indépendance de la Namibie',
          referenceValue: 1990,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-008-i1', 'pio-008-i2', 'pio-008-i3', 'pio-008-i4', 'pio-008-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-009',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Range ces étapes de l\'histoire de la médecine et de la génétique de '
          'la plus ancienne à la plus récente.',
      explanationFr: 'L\'ordre est : le premier vaccin contre la variole par '
          'Jenner (1796), la découverte de la pénicilline par Fleming (1928), la '
          'structure de l\'ADN publiée par Watson et Crick (1953), la naissance '
          'de la brebis Dolly (1996) puis l\'achèvement du séquençage du génome '
          'humain (2003).',
      sourceReference: 'Organisation mondiale de la santé, histoire de la '
          'vaccination ; Human Genome Project, chronologie',
      factGroupId: 'fg-medicine-milestones',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-009-i1',
          label: 'Premier vaccin contre la variole (Edward Jenner)',
          referenceValue: 1796,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-009-i2',
          label: 'Découverte de la pénicilline (Alexander Fleming)',
          referenceValue: 1928,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-009-i3',
          label: 'Publication de la structure de l\'ADN',
          referenceValue: 1953,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-009-i4',
          label: 'Naissance de la brebis Dolly',
          referenceValue: 1996,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-009-i5',
          label: 'Achèvement du séquençage du génome humain',
          referenceValue: 2003,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-009-i1', 'pio-009-i2', 'pio-009-i3', 'pio-009-i4', 'pio-009-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-010',
      category: QuestionCategory.history,
      difficulty: Difficulty.medium,
      text: 'Range ces moments de l\'histoire diplomatique du plus ancien au plus récent.',
      explanationFr: 'L\'ordre est : les traités de Westphalie (1648), le '
          'congrès de Vienne (1815), le traité de Versailles (1919), la '
          'signature de la Charte des Nations unies (1945) puis l\'accord de '
          'Paris sur le climat (2015).',
      sourceReference: 'Nations unies, Histoire de la Charte ; CCNUCC, accord '
          'de Paris ; Encyclopaedia Britannica, articles historiques correspondants',
      factGroupId: 'fg-diplomacy-milestones',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-010-i1',
          label: 'Traités de Westphalie',
          referenceValue: 1648,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-010-i2',
          label: 'Congrès de Vienne',
          referenceValue: 1815,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-010-i3',
          label: 'Traité de Versailles',
          referenceValue: 1919,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-010-i4',
          label: 'Signature de la Charte des Nations unies',
          referenceValue: 1945,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-010-i5',
          label: 'Accord de Paris sur le climat',
          referenceValue: 2015,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-010-i1', 'pio-010-i2', 'pio-010-i3', 'pio-010-i4', 'pio-010-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-011',
      category: QuestionCategory.sports,
      difficulty: Difficulty.easy,
      text: 'Range ces compétitions sportives par leur création, de la plus '
          'ancienne à la plus récente.',
      explanationFr: 'L\'ordre est : les Jeux olympiques modernes (1896), le '
          'Tour de France (1903), le Super Bowl (1967), la première Coupe du '
          'monde de rugby (1987) puis le Tournoi des Six Nations sous sa forme '
          'actuelle (2000).',
      sourceReference: 'Comité international olympique ; Tour de France, '
          'archives ; NFL ; World Rugby ; Six Nations Rugby',
      factGroupId: 'fg-sport-events-creation',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-011-i1',
          label: 'Premiers Jeux olympiques modernes',
          referenceValue: 1896,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-011-i2',
          label: 'Premier Tour de France',
          referenceValue: 1903,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-011-i3',
          label: 'Premier Super Bowl',
          referenceValue: 1967,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-011-i4',
          label: 'Première Coupe du monde de rugby',
          referenceValue: 1987,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-011-i5',
          label: 'Premier Tournoi des Six Nations sous sa forme actuelle',
          referenceValue: 2000,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-011-i1', 'pio-011-i2', 'pio-011-i3', 'pio-011-i4', 'pio-011-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-012',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Range ces groupes du vivant du plus récent au plus ancien.',
      explanationFr: 'L\'ordre, du plus récent au plus ancien, est : Homo sapiens '
          '(il y a environ 300 000 ans), les mammouths (il y a environ 5 '
          'millions d\'années) puis les dinosaures (il y a environ 230 millions '
          'd\'années).',
      sourceReference: 'Encyclopaedia Britannica, articles « Dinosaur », '
          '« Mammoth » et « Homo sapiens » ; Smithsonian, programme « Human Origins »',
      factGroupId: 'fg-life-forms-appearance',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-012-i1',
          label: 'Apparition des dinosaures',
          referenceValue: 230000000,
          unit: 'années avant aujourd\'hui',
        ),
        OrderableItem(
          id: 'pio-012-i2',
          label: 'Apparition des mammouths',
          referenceValue: 5000000,
          unit: 'années avant aujourd\'hui',
        ),
        OrderableItem(
          id: 'pio-012-i3',
          label: 'Apparition d\'Homo sapiens',
          referenceValue: 300000,
          unit: 'années avant aujourd\'hui',
        ),
      ],
      correctOrderIds: ['pio-012-i3', 'pio-012-i2', 'pio-012-i1'],
    ),
    PutInOrderQuestion(
      id: 'pio-013',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Range ces mouvements artistiques de leur émergence la plus ancienne à '
          'la plus récente.',
      explanationFr: 'L\'ordre est : la Renaissance italienne (XVe siècle), le '
          'baroque (début du XVIIe siècle), le romantisme (début du XIXe '
          'siècle), l\'impressionnisme (années 1870) puis le cubisme (à partir '
          'de 1907).',
      sourceReference: 'Encyclopaedia Britannica, articles « Renaissance », '
          '« Baroque », « Romanticism », « Impressionism » et « Cubism »',
      factGroupId: 'fg-art-movements-timeline',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-013-i1',
          label: 'Renaissance italienne',
          referenceValue: 1400,
          unit: 'année (début du mouvement)',
        ),
        OrderableItem(
          id: 'pio-013-i2',
          label: 'Baroque',
          referenceValue: 1600,
          unit: 'année (début du mouvement)',
        ),
        OrderableItem(
          id: 'pio-013-i3',
          label: 'Romantisme',
          referenceValue: 1800,
          unit: 'année (début du mouvement)',
        ),
        OrderableItem(
          id: 'pio-013-i4',
          label: 'Impressionnisme',
          referenceValue: 1870,
          unit: 'année (début du mouvement)',
        ),
        OrderableItem(
          id: 'pio-013-i5',
          label: 'Cubisme',
          referenceValue: 1907,
          unit: 'année (début du mouvement)',
        ),
      ],
      correctOrderIds: ['pio-013-i1', 'pio-013-i2', 'pio-013-i3', 'pio-013-i4', 'pio-013-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-014',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Range ces capitales africaines de la plus méridionale à la plus '
          'septentrionale.',
      explanationFr: 'L\'ordre, du sud au nord, est : Pretoria (environ 25,7° de '
          'latitude sud), Antananarivo (environ 18,9° sud), Nairobi (environ '
          '1,3° sud), Dakar (environ 14,7° nord) puis Le Caire (environ 30° '
          'nord). La latitude est comptée négativement vers le sud.',
      sourceReference: 'Encyclopaedia Britannica, articles correspondants ; '
          'National Geographic, atlas',
      factGroupId: 'fg-african-capitals-latitude',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-014-i1',
          label: 'Pretoria',
          referenceValue: -25.7,
          unit: 'degrés de latitude',
        ),
        OrderableItem(
          id: 'pio-014-i2',
          label: 'Antananarivo',
          referenceValue: -18.9,
          unit: 'degrés de latitude',
        ),
        OrderableItem(
          id: 'pio-014-i3',
          label: 'Nairobi',
          referenceValue: -1.3,
          unit: 'degrés de latitude',
        ),
        OrderableItem(
          id: 'pio-014-i4',
          label: 'Dakar',
          referenceValue: 14.7,
          unit: 'degrés de latitude',
        ),
        OrderableItem(
          id: 'pio-014-i5',
          label: 'Le Caire',
          referenceValue: 30.0,
          unit: 'degrés de latitude',
        ),
      ],
      correctOrderIds: ['pio-014-i1', 'pio-014-i2', 'pio-014-i3', 'pio-014-i4', 'pio-014-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-015',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Range ces pays du moins peuplé au plus peuplé.',
      explanationFr: 'L\'ordre est : le Vatican (moins d\'un millier '
          'd\'habitants), Nauru (environ 12 000), l\'Islande (environ 390 000), '
          'la Suisse (environ 9 millions) puis le Nigeria (plus de 220 '
          'millions).',
      sourceReference: 'Nations unies, World Population Prospects ; '
          'Saint-Siège, statistiques',
      factGroupId: 'fg-country-populations-scale',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-015-i1',
          label: 'Vatican',
          referenceValue: 500,
          unit: 'habitants',
        ),
        OrderableItem(
          id: 'pio-015-i2',
          label: 'Nauru',
          referenceValue: 12000,
          unit: 'habitants',
        ),
        OrderableItem(
          id: 'pio-015-i3',
          label: 'Islande',
          referenceValue: 390000,
          unit: 'habitants',
        ),
        OrderableItem(
          id: 'pio-015-i4',
          label: 'Suisse',
          referenceValue: 8900000,
          unit: 'habitants',
        ),
        OrderableItem(
          id: 'pio-015-i5',
          label: 'Nigeria',
          referenceValue: 223000000,
          unit: 'habitants',
        ),
      ],
      correctOrderIds: ['pio-015-i1', 'pio-015-i2', 'pio-015-i3', 'pio-015-i4', 'pio-015-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-016',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Range ces planètes du Système solaire de la plus proche du Soleil à '
          'la plus éloignée.',
      explanationFr: 'L\'ordre est : Mercure (0,39 unité astronomique du '
          'Soleil), Vénus (0,72), la Terre (1), Mars (1,52) puis Jupiter (5,2). '
          'Une unité astronomique vaut environ 150 millions de kilomètres.',
      sourceReference: 'NASA, fiche des distances planétaires',
      factGroupId: 'fg-planets-distance',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-016-i1',
          label: 'Mercure',
          referenceValue: 0.39,
          unit: 'unités astronomiques',
        ),
        OrderableItem(
          id: 'pio-016-i2',
          label: 'Vénus',
          referenceValue: 0.72,
          unit: 'unités astronomiques',
        ),
        OrderableItem(
          id: 'pio-016-i3',
          label: 'Terre',
          referenceValue: 1.0,
          unit: 'unités astronomiques',
        ),
        OrderableItem(
          id: 'pio-016-i4',
          label: 'Mars',
          referenceValue: 1.52,
          unit: 'unités astronomiques',
        ),
        OrderableItem(
          id: 'pio-016-i5',
          label: 'Jupiter',
          referenceValue: 5.2,
          unit: 'unités astronomiques',
        ),
      ],
      correctOrderIds: ['pio-016-i1', 'pio-016-i2', 'pio-016-i3', 'pio-016-i4', 'pio-016-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-017',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'Range ces dirigeants par leur arrivée au pouvoir, de la plus ancienne '
          'à la plus récente.',
      explanationFr: 'L\'ordre est : Napoléon Ier, couronné empereur en 1804, '
          'Abraham Lincoln en 1861, Winston Churchill en 1940, Nelson Mandela en '
          '1994 puis Angela Merkel en 2005.',
      sourceReference: 'Encyclopaedia Britannica, articles biographiques correspondants',
      factGroupId: 'fg-leaders-rise',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-017-i1',
          label: 'Napoléon Ier, empereur des Français',
          referenceValue: 1804,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-017-i2',
          label: 'Abraham Lincoln, président des États-Unis',
          referenceValue: 1861,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-017-i3',
          label: 'Winston Churchill, Premier ministre britannique',
          referenceValue: 1940,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-017-i4',
          label: 'Nelson Mandela, président de l\'Afrique du Sud',
          referenceValue: 1994,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-017-i5',
          label: 'Angela Merkel, chancelière allemande',
          referenceValue: 2005,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-017-i1', 'pio-017-i2', 'pio-017-i3', 'pio-017-i4', 'pio-017-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-018',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'Range ces animaux africains du plus petit au plus grand (hauteur au garrot).',
      explanationFr: 'L\'ordre, du plus petit au plus grand, est : le suricate '
          '(environ 30 cm), le zèbre (environ 1,4 m), l\'éléphant de savane '
          '(environ 3,2 m au garrot) puis la girafe (jusqu\'à environ 5,3 m).',
      sourceReference: 'San Diego Zoo, fiches animales ; Encyclopaedia '
          'Britannica, articles correspondants',
      factGroupId: 'fg-african-animals-size',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-018-i1',
          label: 'Suricate',
          referenceValue: 0.3,
          unit: 'mètre au garrot',
        ),
        OrderableItem(
          id: 'pio-018-i2',
          label: 'Zèbre',
          referenceValue: 1.4,
          unit: 'mètre au garrot',
        ),
        OrderableItem(
          id: 'pio-018-i3',
          label: 'Éléphant de savane',
          referenceValue: 3.2,
          unit: 'mètre au garrot',
        ),
        OrderableItem(
          id: 'pio-018-i4',
          label: 'Girafe',
          referenceValue: 5.3,
          unit: 'mètre au garrot',
        ),
      ],
      correctOrderIds: ['pio-018-i1', 'pio-018-i2', 'pio-018-i3', 'pio-018-i4'],
    ),
    PutInOrderQuestion(
      id: 'pio-019',
      category: QuestionCategory.arts,
      difficulty: Difficulty.easy,
      text: 'Range ces musées par leur ouverture au public, de la plus ancienne à '
          'la plus récente.',
      explanationFr: 'L\'ordre est : le British Museum, ouvert en 1759, le '
          'Louvre en 1793, le Museum of Modern Art de New York en 1929, le '
          'Centre Pompidou en 1977 puis le Louvre Abu Dhabi en 2017.',
      sourceReference: 'British Museum, histoire du musée ; Louvre ; MoMA ; '
          'Centre Pompidou ; Louvre Abu Dhabi',
      factGroupId: 'fg-museums-opening',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-019-i1',
          label: 'British Museum (Londres)',
          referenceValue: 1759,
          unit: 'année d\'ouverture',
        ),
        OrderableItem(
          id: 'pio-019-i2',
          label: 'Musée du Louvre (Paris)',
          referenceValue: 1793,
          unit: 'année d\'ouverture',
        ),
        OrderableItem(
          id: 'pio-019-i3',
          label: 'Museum of Modern Art (New York)',
          referenceValue: 1929,
          unit: 'année d\'ouverture',
        ),
        OrderableItem(
          id: 'pio-019-i4',
          label: 'Centre Pompidou (Paris)',
          referenceValue: 1977,
          unit: 'année d\'ouverture',
        ),
        OrderableItem(
          id: 'pio-019-i5',
          label: 'Louvre Abu Dhabi',
          referenceValue: 2017,
          unit: 'année d\'ouverture',
        ),
      ],
      correctOrderIds: ['pio-019-i1', 'pio-019-i2', 'pio-019-i3', 'pio-019-i4', 'pio-019-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-020',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Range ces étapes de l\'exploration spatiale de la plus ancienne à la '
          'plus récente.',
      explanationFr: 'L\'ordre est : Spoutnik 1 (1957), le premier vol habité '
          'de Gagarine (1961), les premiers pas sur la Lune d\'Apollo 11 (1969), '
          'le lancement de Voyager 1 (1977) puis l\'atterrissage du rover '
          'Curiosity sur Mars (2012).',
      sourceReference: 'NASA, chronologie des missions',
      factGroupId: 'fg-space-exploration-timeline',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-020-i1',
          label: 'Lancement du satellite Spoutnik 1',
          referenceValue: 1957,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-020-i2',
          label: 'Premier vol habité (Youri Gagarine)',
          referenceValue: 1961,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-020-i3',
          label: 'Premiers pas sur la Lune (Apollo 11)',
          referenceValue: 1969,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-020-i4',
          label: 'Lancement de la sonde Voyager 1',
          referenceValue: 1977,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-020-i5',
          label: 'Atterrissage du rover Curiosity sur Mars',
          referenceValue: 2012,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-020-i1', 'pio-020-i2', 'pio-020-i3', 'pio-020-i4', 'pio-020-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-021',
      category: QuestionCategory.nature,
      difficulty: Difficulty.medium,
      text: 'Range ces déplacements du plus lent au plus rapide.',
      explanationFr: 'L\'ordre est : la tortue terrestre (environ 0,3 km/h), '
          'l\'autruche (environ 70 km/h), le guépard (environ 110 km/h), le '
          'faucon pèlerin en piqué (plus de 300 km/h) puis un avion de ligne '
          '(environ 900 km/h).',
      sourceReference: 'Encyclopaedia Britannica, articles « Cheetah » et '
          '« Peregrine falcon » ; San Diego Zoo',
      factGroupId: 'fg-speed-records',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-021-i1',
          label: 'Tortue terrestre',
          referenceValue: 0.3,
          unit: 'km/h',
        ),
        OrderableItem(
          id: 'pio-021-i2',
          label: 'Autruche',
          referenceValue: 70,
          unit: 'km/h',
        ),
        OrderableItem(
          id: 'pio-021-i3',
          label: 'Guépard',
          referenceValue: 110,
          unit: 'km/h',
        ),
        OrderableItem(
          id: 'pio-021-i4',
          label: 'Faucon pèlerin en piqué',
          referenceValue: 300,
          unit: 'km/h',
        ),
        OrderableItem(
          id: 'pio-021-i5',
          label: 'Avion de ligne long-courrier',
          referenceValue: 900,
          unit: 'km/h',
        ),
      ],
      correctOrderIds: ['pio-021-i1', 'pio-021-i2', 'pio-021-i3', 'pio-021-i4', 'pio-021-i5'],
    ),
    PutInOrderQuestion(
      id: 'pio-022',
      category: QuestionCategory.sports,
      difficulty: Difficulty.medium,
      text: 'Range ces événements sportifs par leur première édition, de la plus '
          'ancienne à la plus récente.',
      explanationFr: 'L\'ordre est : les Jeux olympiques modernes d\'Athènes '
          '(1896), le premier Tour de France (1903), le premier Super Bowl '
          '(1967), la première Coupe du monde de rugby (1987) puis la première '
          'Coupe du monde féminine de football (1991).',
      sourceReference: 'Comité international olympique ; Tour de France, '
          'archives ; NFL ; World Rugby ; FIFA',
      factGroupId: 'fg-sport-events-first-edition',
      createdAt: _createdAt,
      items: [
        OrderableItem(
          id: 'pio-022-i1',
          label: 'Jeux olympiques modernes d\'Athènes',
          referenceValue: 1896,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-022-i2',
          label: 'Premier Tour de France',
          referenceValue: 1903,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-022-i3',
          label: 'Premier Super Bowl',
          referenceValue: 1967,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-022-i4',
          label: 'Première Coupe du monde de rugby',
          referenceValue: 1987,
          unit: 'année',
        ),
        OrderableItem(
          id: 'pio-022-i5',
          label: 'Première Coupe du monde féminine de football',
          referenceValue: 1991,
          unit: 'année',
        ),
      ],
      correctOrderIds: ['pio-022-i1', 'pio-022-i2', 'pio-022-i3', 'pio-022-i4', 'pio-022-i5'],
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

    // --- Batch 2 -------------------------------------------------------------

    HowMuchQuestion(
      id: 'hm-008',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Combien de planètes compte le Système solaire ?',
      explanationFr: 'Le Système solaire compte huit planètes : Mercure, Vénus, '
          'la Terre, Mars, Jupiter, Saturne, Uranus et Neptune. Pluton a été '
          'reclassée comme planète naine en 2006.',
      sourceReference: 'Union astronomique internationale, définition d\'une planète',
      factGroupId: 'fg-solar-planets-count',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 8,
        unit: 'planètes',
        unitFr: 'planètes',
        acceptedMin: 8,
        acceptedMax: 8,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-009',
      category: QuestionCategory.general,
      difficulty: Difficulty.easy,
      text: 'Combien de pays sont membres de l\'Union européenne ?',
      explanationFr: 'L\'Union européenne compte 27 États membres depuis le '
          'retrait du Royaume-Uni, effectif le 31 janvier 2020.',
      sourceReference: 'Union européenne, liste des pays membres',
      factGroupId: 'fg-eu-members',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 27,
        unit: 'pays',
        unitFr: 'pays',
        acceptedMin: 27,
        acceptedMax: 27,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-010',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Combien de chromosomes contient une cellule humaine ordinaire ?',
      explanationFr: 'Une cellule humaine normale contient 46 chromosomes, '
          'soit 23 paires. Les gamètes n\'en contiennent que 23.',
      sourceReference: 'National Human Genome Research Institute, '
          '« How many chromosomes do people have? »',
      factGroupId: 'fg-human-chromosomes',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 46,
        unit: 'chromosomes',
        unitFr: 'chromosomes',
        acceptedMin: 46,
        acceptedMax: 46,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-011',
      category: QuestionCategory.geography,
      difficulty: Difficulty.hard,
      text: 'Quelle est la longueur approximative du Nil, en kilomètres ?',
      explanationFr: 'Le Nil mesure environ 6 650 km, ce qui en fait '
          'traditionnellement le plus long fleuve d\'Afrique, de l\'Afrique de '
          'l\'Est à la Méditerranée.',
      sourceReference: 'Encyclopaedia Britannica, article « Nile River »',
      factGroupId: 'fg-nile-length',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 6650,
        unit: 'km',
        unitFr: 'kilomètres',
        acceptedMin: 6000,
        acceptedMax: 7000,
        scoringRuleId: 'proximity_range',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-012',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'Quelle est la hauteur du Kilimandjaro, en mètres ?',
      explanationFr: 'Le Kilimandjaro, en Tanzanie, culmine à 5 895 mètres au '
          'sommet Uhuru. C\'est le point culminant de l\'Afrique.',
      sourceReference: 'UNESCO, parc national du Kilimandjaro',
      factGroupId: 'fg-kilimanjaro-height',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 5895,
        unit: 'mètres',
        unitFr: 'mètres',
        acceptedMin: 5500,
        acceptedMax: 6000,
        scoringRuleId: 'proximity_range',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-013',
      category: QuestionCategory.africa,
      difficulty: Difficulty.medium,
      text: 'En quelle année l\'Afrique du Sud a-t-elle organisé sa première '
          'élection présidentielle multiraciale ?',
      explanationFr: 'L\'Afrique du Sud a tenu ses premières élections au '
          'suffrage universel multiracial du 26 au 29 avril 1994, qui ont '
          'porté Nelson Mandela à la présidence.',
      sourceReference: 'Encyclopaedia Britannica, article « South Africa » ; '
          'Commission électorale indépendante sud-africaine',
      factGroupId: 'fg-southafrica-election-1994',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1994,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1994,
        acceptedMax: 1994,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-014',
      category: QuestionCategory.history,
      difficulty: Difficulty.easy,
      text: 'En quelle année a eu lieu la prise de la Bastille, à Paris ?',
      explanationFr: 'La prison de la Bastille a été prise par les Parisiens le '
          '14 juillet 1789, événement fondateur de la Révolution française.',
      sourceReference: 'Encyclopaedia Britannica, article « Storming of the Bastille »',
      factGroupId: 'fg-bastille-1789',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1789,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1789,
        acceptedMax: 1789,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-015',
      category: QuestionCategory.sports,
      difficulty: Difficulty.easy,
      text: 'Combien de joueurs une équipe de volleyball aligne-t-elle sur le '
          'terrain ?',
      explanationFr: 'Une équipe de volleyball aligne six joueurs sur le '
          'terrain. Le libero, spécialiste défensif, porte un maillot de couleur '
          'différente.',
      sourceReference: 'Fédération internationale de volleyball, règles du jeu',
      factGroupId: 'fg-volleyball-players',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 6,
        unit: 'joueurs',
        unitFr: 'joueurs',
        acceptedMin: 6,
        acceptedMax: 6,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-016',
      category: QuestionCategory.science,
      difficulty: Difficulty.hard,
      text: 'Combien de minutes la lumière du Soleil met-elle pour atteindre la '
          'Terre ?',
      explanationFr: 'La distance moyenne Terre-Soleil est d\'environ 150 '
          'millions de kilomètres. Le trajet prend environ 8 minutes et 20 '
          'secondes.',
      sourceReference: 'NASA, fiche sur la vitesse de la lumière',
      factGroupId: 'fg-light-travel-minutes',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 8.3,
        unit: 'minutes',
        unitFr: 'minutes',
        acceptedMin: 8,
        acceptedMax: 9,
        scoringRuleId: 'proximity_range',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-017',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Combien de cœurs possède un poulpe ?',
      explanationFr: 'Le poulpe possède trois cœurs : deux cœurs branchiaux '
          'qui pompent le sang vers les branchies et un cœur systémique qui le '
          'distribue au reste du corps.',
      sourceReference: 'Encyclopaedia Britannica, article « Octopus »',
      factGroupId: 'fg-octopus-hearts',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 3,
        unit: 'cœurs',
        unitFr: 'cœurs',
        acceptedMin: 3,
        acceptedMax: 3,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-018',
      category: QuestionCategory.technology,
      difficulty: Difficulty.medium,
      text: 'Combien de caractères contient un SMS classique ?',
      explanationFr: 'La norme GSMA limite un SMS en alphabet latin à 160 '
          'caractères, au-delà desquels le message est fragmenté en plusieurs '
          'SMS.',
      sourceReference: 'GSMA, spécifications des SMS',
      factGroupId: 'fg-sms-length',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 160,
        unit: 'caractères',
        unitFr: 'caractères',
        acceptedMin: 160,
        acceptedMax: 160,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-019',
      category: QuestionCategory.africa,
      difficulty: Difficulty.easy,
      text: 'En quelle année le Nigeria est-il devenu indépendant du Royaume-Uni ?',
      explanationFr: 'Le Nigeria a accédé à l\'indépendance le 1er octobre '
          '1960. Abuja est devenue la capitale en 1991, en remplacement de Lagos.',
      sourceReference: 'Encyclopaedia Britannica, article « Nigeria » ; '
          'Nations unies, chronologie de la décolonisation',
      factGroupId: 'fg-nigeria-independence-1960',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1960,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1960,
        acceptedMax: 1960,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-020',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Combien de fuseaux horaires la Russie compte-t-elle ?',
      explanationFr: 'La Russie utilise onze fuseaux horaires, du kaliningrad '
          '(UTC+2) au kamtchatka (UTC+12), sur neuf régions horaires '
          'administratives.',
      sourceReference: 'Encyclopaedia Britannica, article « Russia » ; '
          'IANA, base des fuseaux horaires',
      factGroupId: 'fg-russia-timezones',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 11,
        unit: 'fuseaux horaires',
        unitFr: 'fuseaux horaires',
        acceptedMin: 11,
        acceptedMax: 11,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-021',
      category: QuestionCategory.arts,
      difficulty: Difficulty.medium,
      text: 'Combien de symphonies Beethoven a-t-il composées ?',
      explanationFr: 'Beethoven a composé neuf symphonies numérotées. La '
          'neuvième,avec l\'Ode à la joie, a été créée à Vienne en 1824.',
      sourceReference: 'Orchestre philharmonique de Vienne ; '
          'Encyclopaedia Britannica, article « Ludwig van Beethoven »',
      factGroupId: 'fg-beethoven-symphonies',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 9,
        unit: 'symphonies',
        unitFr: 'symphonies',
        acceptedMin: 9,
        acceptedMax: 9,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-022',
      category: QuestionCategory.science,
      difficulty: Difficulty.easy,
      text: 'Combien d\'os compte le squelette d\'un adulte ?',
      explanationFr: 'Le squelette humain adulte compte 206 os. À la '
          'naissance on en dénombre environ 300, dont certains fusionnent en '
          'grandissant.',
      sourceReference: 'National Institute of Arthritis and Musculoskeletal and '
          'Skin Diseases, squelette humain',
      factGroupId: 'fg-human-bones',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 206,
        unit: 'os',
        unitFr: 'os',
        acceptedMin: 206,
        acceptedMax: 206,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-023',
      category: QuestionCategory.africa,
      difficulty: Difficulty.hard,
      text: 'En quelle année Nelson Mandela a-t-il été libéré de prison ?',
      explanationFr: 'Nelson Mandela a été libéré de la prison de Victor '
          'Verster le 11 février 1990, après vingt-sept ans de détention.',
      sourceReference: 'Nelson Mandela Foundation, chronologie ; '
          'Encyclopaedia Britannica, article « Nelson Mandela »',
      factGroupId: 'fg-mandela-release-1990',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 1990,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 1990,
        acceptedMax: 1990,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-024',
      category: QuestionCategory.sports,
      difficulty: Difficulty.medium,
      text: 'Combien d\'anneaux le drapeau olympique compte-t-il ?',
      explanationFr: 'Les cinq anneaux entrelacés du drapeau olympique '
          'représentent les cinq continents réunis par l\'olympisme. Le drapeau '
          'a été hissé pour la première fois en 1920.',
      sourceReference: 'Comité international olympique, symboles olympiques',
      factGroupId: 'fg-olympic-rings',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 5,
        unit: 'anneaux',
        unitFr: 'anneaux',
        acceptedMin: 5,
        acceptedMax: 5,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-025',
      category: QuestionCategory.nature,
      difficulty: Difficulty.easy,
      text: 'Combien de pattes possède une araignée adulte ?',
      explanationFr: 'Les araignées sont des arachnides et possèdent huit '
          'pattes, contrairement aux insectes qui en ont six.',
      sourceReference: 'Encyclopaedia Britannica, article « Spider »',
      factGroupId: 'fg-spider-legs',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 8,
        unit: 'pattes',
        unitFr: 'pattes',
        acceptedMin: 8,
        acceptedMax: 8,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-026',
      category: QuestionCategory.technology,
      difficulty: Difficulty.hard,
      text: 'En quelle année le premier iPhone est-il commercialisé ?',
      explanationFr: 'Le premier iPhone a été mis en vente aux États-Unis le '
          '29 juin 2007, quelques mois après sa présentation publique en janvier.',
      sourceReference: 'Apple, communiqué de presse de 2007',
      factGroupId: 'fg-iphone-2007',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 2007,
        unit: 'année',
        unitFr: 'année',
        acceptedMin: 2007,
        acceptedMax: 2007,
        scoringRuleId: 'exact_match',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-027',
      category: QuestionCategory.science,
      difficulty: Difficulty.medium,
      text: 'Quel est le pourcentage approximatif de l\'oxygène dans l\'air ambiant ?',
      explanationFr: 'L\'air sec contient environ 78 % d\'azote et 21 % '
          'd\'oxygène, le reste étant principalement de l\'argon et du dioxyde '
          'de carbone.',
      sourceReference: 'Administration nationale océanique et atmosphérique, '
          'composition de l\'atmosphère',
      factGroupId: 'fg-oxygen-percentage',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 21,
        unit: 'pour cent',
        unitFr: 'pour cent',
        acceptedMin: 20,
        acceptedMax: 22,
        scoringRuleId: 'proximity_range',
      ),
    ),
    HowMuchQuestion(
      id: 'hm-028',
      category: QuestionCategory.geography,
      difficulty: Difficulty.medium,
      text: 'Quelle est la distance approximative à vol d\'oiseau entre Le Cap '
          'et Nairobi, en kilomètres ?',
      explanationFr: 'Le trajet orthodromique entre Le Cap et Nairobi est '
          'd\'environ 3 000 km, soit près de quatre heures de vol.',
      sourceReference: 'Distances aéronautiques publiées par l\'OACI ; '
          'calculs orthodromiques de référence',
      factGroupId: 'fg-capetown-nairobi-distance',
      createdAt: _createdAt,
      answer: EstimationAnswer(
        referenceValue: 3000,
        unit: 'km',
        unitFr: 'kilomètres',
        acceptedMin: 2700,
        acceptedMax: 3300,
        scoringRuleId: 'proximity_range',
      ),
    ),
  ];
}
