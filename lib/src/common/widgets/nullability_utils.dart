T requireNotNull<T>(T? value, {String? name}) {
  if (value == null) {
    throw ArgumentError.notNull(name);
  }
  return value;
}
