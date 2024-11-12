import 'dart:convert' as convert;

import 'package:meta/meta.dart';

import 'json.dart';

///Class to easily handle shared preferences in a type-safe way
sealed class SpCache<T> {
  const SpCache(this.sP, {required this.key});
  @protected
  final SharedPreferences sP;
  @protected
  final String key;
  @protected
  T? get();
  @protected
  Future<bool> put(T value);
  Future<void> delete() => sP.remove(key);
}

///Class to handle shared preferences of type "String"
class SpStringCache extends SpCache<String> {
  const SpStringCache(super.sP, {required super.key});

  @override
  String? get() => sP.getString(key);

  @override
  Future<bool> put(String value) => sP.setString(key, value);
}

///Class to handle shared preferences of type "int"
class SpIntCache extends SpCache<int> {
  const SpIntCache(super.sP, {required super.key});

  @override
  int? get() => sP.getInt(key);

  @override
  Future<bool> put(int value) => sP.setInt(key, value);
}

///Class to handle shared preferences of type "double"
class SpDoubleCache extends SpCache<double> {
  const SpDoubleCache(super.sP, {required super.key});

  @override
  double? get() => sP.getDouble(key);

  @override
  Future<bool> put(double value) => sP.setDouble(key, value);
}

///Class to handle shared preferences of type "bool"
class SpBoolCache extends SpCache<bool> {
  const SpBoolCache(super.sP, {required super.key});

  @override
  bool? get() => sP.getBool(key);

  @override
  Future<bool> put(bool value) => sP.setBool(key, value);
}

///Class to handle shared preferences of type "Json"
class SpJsonCache<T extends Object> extends SpCache<T> {
  const SpJsonCache(
    super.sP, {
    required super.key,
    required this.toJson,
    required this.fromJson,
  });
  @protected
  final Json Function(T object) toJson;
  @protected
  final T Function(Json json) fromJson;

  @override
  T? get() {
    final encoded = sP.getString(key);
    if (encoded == null) return null;
    final decoded = convert.jsonDecode(encoded);
    return fromJson(decoded as Json);
  }

  @override
  Future<bool> put(T value) {
    final encoded = convert.jsonEncode(toJson(value));
    return sP.setString(key, encoded);
  }
}

///Class to handle shared preferences of type "List<Json>"
class SpJsonListCache<T extends Object> extends SpCache<List<T>> {
  const SpJsonListCache(
    super.sP, {
    required super.key,
    required this.toJson,
    required this.fromJson,
  });
  @protected
  final Json Function(T object) toJson;
  @protected
  final T Function(Json json) fromJson;

  @override
  List<T>? get() {
    final listEncoded = sP.getStringList(key);
    if (listEncoded == null) return null;
    final listDecoded = [...listEncoded.map((e) => convert.jsonDecode(e) as Json)];
    return [...listDecoded.map(fromJson)];
  }

  @override
  Future<bool> put(List<T> value) {
    final encoded = value.map((e) => convert.jsonEncode(toJson(e)));

    return sP.setStringList(key, [...encoded]);
  }
}
