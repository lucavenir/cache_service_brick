import 'dart:convert' as convert;

// TODO(dario): non possiamo dipendere da `flutter`
// TODO(dario): installare https://pub.dev/packages/meta nei postgen e iniettarlo qui al suo posto
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'json.dart';

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

class SpStringCache extends SpCache<String> {
  const SpStringCache(super.sP, {required super.key});

  @override
  String? get() => sP.getString(key);

  @override
  Future<bool> put(String value) => sP.setString(key, value);
}

class SpIntCache extends SpCache<int> {
  const SpIntCache(super.sP, {required super.key});

  @override
  int? get() => sP.getInt(key);

  @override
  Future<bool> put(int value) => sP.setInt(key, value);
}

class SpDoubleCache extends SpCache<double> {
  const SpDoubleCache(super.sP, {required super.key});

  @override
  double? get() => sP.getDouble(key);

  @override
  Future<bool> put(double value) => sP.setDouble(key, value);
}

class SpBoolCache extends SpCache<bool> {
  const SpBoolCache(super.sP, {required super.key});

  @override
  bool? get() => sP.getBool(key);

  @override
  Future<bool> put(bool value) => sP.setBool(key, value);
}

// TODO(dario): on second thought... we can remove this (it's a subset of `SpJsonListCache`)
class SpStringListCache extends SpCache<List<String>> {
  const SpStringListCache(super.sP, {required super.key});

  @override
  List<String>? get() => sP.getStringList(key);

  @override
  Future<bool> put(List<String> value) => sP.setStringList(key, value);
}

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
    final listDecoded = [
      ...listEncoded.map((e) => convert.jsonDecode(e) as Json)
    ];
    return [...listDecoded.map(fromJson)];
  }

  @override
  Future<bool> put(List<T> value) {
    final encoded = value.map((e) => convert.jsonEncode(toJson(e)));

    return sP.setStringList(key, [...encoded]);
  }
}
