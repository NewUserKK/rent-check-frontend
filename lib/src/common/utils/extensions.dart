extension TakeIf<T> on T? {
  T? takeIf(bool Function(T) predicate) => this == null ? null : predicate(this!) ? this : null;
}

extension TakeIfNotBlank on String? {
  String? takeIfNotBlank() => takeIf((it) => it.trim().isNotEmpty);
}

extension Let<T, R> on T? {
  R? let(R Function(T) block) => this == null ? null : block(this!);
}

extension RemoveNulls on Map<String, dynamic> {
  Map<String, dynamic> removeNulls() {
    final copy = Map<String, dynamic>.from(this);
    copy.removeWhere((k, v) => v == null);
    return copy;
  }
}
