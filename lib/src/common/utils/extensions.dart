extension TakeIf<T> on T? {
  T? takeIf(bool Function(T) predicate) => this == null
      ? null
      : predicate(this as T)
          ? this
          : null;
}

extension TakeIfNotBlank on String? {
  String? takeIfNotBlank() => takeIf((it) => it.trim().isNotEmpty);
}

extension Let<T, R> on T? {
  R? let(R Function(T) block) => this == null ? null : block(this as T);
}

extension RemoveNulls on Map<String, dynamic> {
  Map<String, dynamic> removeNulls() {
    final copy = Map<String, dynamic>.from(this);
    copy.removeWhere((k, v) => v == null);
    return copy;
  }
}

extension SetMap<K, V> on Map<K, V> {
  Map<K, V> modify(K key, V Function(V) valueTransformer) {
    final copy = Map<K, V>.from(this);
    final item = copy[key]!;
    copy[key] = valueTransformer(item);
    return copy;
  }

  Map<K, V> set(K key, V value) {
    final copy = Map<K, V>.from(this);
    copy[key] = value;
    return copy;
  }
}

extension AssociateBy<T> on Iterable<T> {
  Map<K, T> associateBy<K>(K Function(T) keySelector) {
    final map = <K, T>{};
    for (final element in this) {
      map[keySelector(element)] = element;
    }
    return map;
  }
}
