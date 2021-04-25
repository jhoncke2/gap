class EnumValues<V,T> {
  Map<V, T> map;
  Map<T, V> reverseMap;

  EnumValues(this.map);

  Map<T, V> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}