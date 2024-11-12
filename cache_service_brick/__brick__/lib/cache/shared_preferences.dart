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
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

///provider for shared preferences used in spcache's providers
///
@riverpod
FutureOr<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}
