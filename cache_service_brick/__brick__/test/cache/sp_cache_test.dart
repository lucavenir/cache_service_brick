import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../../lib/cache/json.dart';
import '../../lib/cache/sp_cache.dart';

void main() {
  late SharedPreferences sharedPref;
  const key = 'key_test';
  const value = 'value_test';
  group('SpStringCache', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPref = await SharedPreferences.getInstance();
    });

    test('get method return value string', () {
      sharedPref.setString(key, value);
      final spStringCache = SpStringCache(sharedPref, key: key);

      final result = spStringCache.get();
      expect(result, value);
    });

    test('put method, replace with new value', () async {
      final spStringCache = SpStringCache(sharedPref, key: key);

      final result = await spStringCache.put(value);
      expect(result, isTrue);
      expect(sharedPref.getString(key), value);
    });

    test('delete method remove value ', () async {
      await sharedPref.setString(key, value);
      final spStringCache = SpStringCache(sharedPref, key: key);

      await spStringCache.delete();
      expect(sharedPref.getString(key), isNull);
    });
  });

  group('SpIntCache', () {
    const value = 10;

    test('get method return value int', () {
      sharedPref.setInt(key, value);
      final spIntCache = SpIntCache(sharedPref, key: key);

      final result = spIntCache.get();
      expect(result, value);
    });

    test('put method, replace with new value', () async {
      final spIntCache = SpIntCache(sharedPref, key: key);

      final result = await spIntCache.put(value);
      expect(result, isTrue);
      expect(sharedPref.getInt(key), value);
    });
  });

  group('SpDoubleCache', () {
    const value = 2.2;

    test('get method return value double', () {
      sharedPref.setDouble(key, value);
      final spDoubleCache = SpDoubleCache(sharedPref, key: key);

      final result = spDoubleCache.get();
      expect(result, value);
    });

    test('put method, replace with new value', () async {
      final spDoubleCache = SpDoubleCache(sharedPref, key: key);

      final result = await spDoubleCache.put(value);
      expect(result, isTrue);
      expect(sharedPref.getDouble(key), value);
    });
  });

  group('SpBoolCache', () {
    const value = true;

    test('get method return value bool', () {
      sharedPref.setBool(key, value);
      final spBoolCache = SpBoolCache(sharedPref, key: key);

      final result = spBoolCache.get();
      expect(result, value);
    });

    test('put method, replace with new value', () async {
      final spBoolCache = SpBoolCache(sharedPref, key: key);

      final result = await spBoolCache.put(value);
      expect(result, isTrue);
      expect(sharedPref.getBool(key), value);
    });
  });

  group('SpJsonCache', () {
    const Json jsonValue = {'key1': 'value_key_1', 'key2': 'value_key_2'};

    final jsonCache = SpJsonCache<Json>(
      sharedPref,
      key: key,
      toJson: (json) => json,
      fromJson: (json) => json,
    );

    test('get method return value json', () {
      sharedPref.setString(key, convert.jsonEncode(jsonValue));

      final result = jsonCache.get();
      expect(result, jsonValue);
    });

    test('put method, replace with new value', () async {
      final result = await jsonCache.put(jsonValue);
      expect(result, isTrue);
      expect(convert.jsonDecode(sharedPref.getString(key)!), jsonValue);
    });
  });
}
