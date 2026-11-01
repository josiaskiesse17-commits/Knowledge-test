import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The ARB template (French) and its English translation must keep identical
/// key sets, otherwise `flutter gen-l10n` silently drops or adds keys and the
/// two locales stop mirroring each other.
void main() {
  test('app_en.arb and app_fr.arb declare the same keys', () {
    final en = _arbKeys(File('lib/l10n/app_en.arb'));
    final fr = _arbKeys(File('lib/l10n/app_fr.arb'));

    expect(
      fr,
      en,
      reason:
          'ARB drift: French and English key sets differ. '
          'Only French: ${fr.difference(en).join(", ")}. '
          'Only English: ${en.difference(fr).join(", ")}.',
    );
  });
}

Set<String> _arbKeys(File file) {
  final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return decoded.keys.where((key) => !key.startsWith('@')).toSet();
}
