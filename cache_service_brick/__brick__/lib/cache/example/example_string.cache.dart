{{#generation}}
import 'package:riverpod_annotation/riverpod_annotation.dart';
{{/generation}}
{{^generation}}
{{#hooks}}
import 'package:hooks_riverpod/hooks_riverpod.dart';
{{/hooks}}
{{^hooks}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/hooks}}
{{/generation}}

part 'example_string.cache.g.dart';

///Example of a provider that uses the SpStringCache class
///to store a String value in a SharedPreferences
///after injecting, use: delete(), get() and put() methods

@riverpod
SpStringCache exampleStringCache(ExampleStringCacheRef ref) {
  final sP = ref.watch(
    sharedPreferencesProvider.select((sp) => sp.requireValue),
  );
  return SpStringCache(sP, key: 'exampleString');
}
