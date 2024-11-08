import 'dart:io' as io;

import 'package:mason/mason.dart';

Future<void> addDependencies(HookContext context) async {
  final _ = await io.Process.run(
    'flutter',
    ['pub', 'add', 'shared_preferences'],
  );
}
