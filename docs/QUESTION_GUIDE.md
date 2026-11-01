# Guide de contribution — Banque de questions

Ce document décrit le format des questions, le flux de révision et la règle
de source. La banque de questions est la **seule source de vérité** : tous les
tests et l'application la chargent depuis les fichiers JSON de
`assets/questions/`.

## Fichiers de la banque

Chaque mode de jeu a son propre fichier JSON :

| Mode | Fichier | Constante |
|------|---------|-----------|
| Lequel en premier ? | `assets/questions/which_came_first.json` | `whichCameFirst` |
| Devine le pays | `assets/questions/guess_the_country.json` | `guessTheCountry` |
| Fait ou Fake | `assets/questions/fact_or_cap.json` | `factOrCap` |
| Mets dans l'ordre | `assets/questions/put_in_order.json` | `putInOrder` |
| Combien ? | `assets/questions/how_much.json` | `howMuch` |

La liste unique des chemins d'actifs est déclarée dans
`lib/repositories/asset_question_repository.dart` (`questionAssetPaths`). Tout
nouveau fichier de questions doit y être ajouté : un test vérifie que chaque
fichier présent dans `assets/questions/` est listé et chargé, et qu'aucun
chemin listé n'est absent du disque. Ne jamais éditer les fichiers générés
(`lib/l10n/*.dart`) ; regénérez-les avec `flutter gen-l10n`.

## Format par mode

Toutes les questions partagent les métadonnées communes :

```json
{
  "id": "wcf-001",
  "mode": "whichCameFirst",
  "variation": "chronology",
  "category": "history",
  "difficulty": "easy",
  "text": "...",
  "explanationFr": "...",
  "sourceReference": "...",
  "factGroupId": "...",
  "language": "french",
  "reviewStatus": "reviewed",
  "createdAt": "2025-01-01T00:00:00Z"
}
```

Chaque mode ajoute ses données de réponse spécifiques :

### whichCameFirst
`events` : liste d'événements avec `id`, `label`, `referenceValue` (année) et
éventuellement `unit`. `correctFirstIndex` / `correctSecondIndex` donnent les
index des deux événements à ordonner.

### guessTheCountry
`targetCountry` : nom du pays. `clues` : liste d'indices avec `id`, `text`,
`revealed` et éventuellement `imageUrl`.

### factOrCap
`statements` : liste d'affirmations avec `id`, `text`, `isTrue`.
`falseStatementsIds` : ids des affirmations fausses (pour "trouvez la fausse").

### putInOrder
`items` : liste d'éléments avec `id`, `label`, `description`, `referenceValue`,
`unit`. `correctOrderIds` : ids dans le bon ordre.

### howMuch
`answer` : `referenceValue` (cible numérique), `unit`, `unit?Fr`,
`acceptedMin`, `acceptedMax` (plage acceptée), `scoringRuleId`,
`significantFigures`. Une question "Combien ?" doit définir sa cible par une
valeur de référence et/ou une plage acceptée.

## Statut de révision

Flux : **draft → reviewed → approved**.

- `draft` : brouillon, faits non vérifiés. Jamais servi aux joueurs.
- `reviewed` : relu, source vérifiée. Servi aux joueurs.
- `approved` : validé définitivement. Servi aux joueurs.
- `deprecated` : retiré. Jamais servi.

Le dépôt (`AssetQuestionRepository`) ne sert que les questions
`approved` et `reviewed`. Les questions `draft` et `deprecated` sont ignorées
et consignées dans `loadErrors` lors du chargement.

Toutes les questions de la banque actuelle sont `reviewed` : leurs faits
n'ont pas encore été pleinement vérifiés. Lorsqu'un fait est vérifié, passez
le statut à `approved`.

## Règle de source

**Chaque question doit disposer d'une source vérifiable (`sourceReference`).**
Une question sans source, ou dont le fait ne peut être vérifié, ne doit pas
atteindre le statut `approved` (ni même être conservée en l'état dans la
banque). Privilégiez les références primaires ou institutionnelles
(encyclopédies, institutions publiques, organismes officiels) et indiquez
précisément l'article ou la page consultée.

## Ajouter un fichier de questions

1. Créez le fichier JSON dans `assets/questions/` suivant le format du mode.
2. Ajoutez son chemin à `questionAssetPaths` dans
   `lib/repositories/asset_question_repository.dart`.
3. Vérifiez que chaque question a un `id` unique dans l'ensemble des fichiers,
   un `sourceReference`, une `explanationFr`, un `factGroupId` non vides, et un
   statut de révision cohérent.
4. Régénérez les localisations si besoin : `flutter gen-l10n`.
5. Lancez `dart format`, `flutter analyze` et `flutter test`.
