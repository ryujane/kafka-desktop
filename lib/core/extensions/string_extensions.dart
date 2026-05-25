extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension NullableStringX on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;
  bool get isNotBlank => !isBlank;
}
