/// Parses an ISO-8601 timestamp, returning null when it is missing or unusable.
///
/// Stored data can come from an older version of the app, so dates are read
/// defensively instead of throwing.
DateTime? parseDateOrNull(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

/// Looks up an enum value by name, falling back to [fallback] for unknown names.
T? enumByNameOrNull<T extends Enum>(Iterable<T> values, Object? name) {
  if (name is! String) return null;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
