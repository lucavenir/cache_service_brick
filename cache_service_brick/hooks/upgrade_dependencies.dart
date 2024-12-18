import 'dart:io' as io;

import 'package:mason/mason.dart';

Future<void> upgradeDependencies(HookContext context) async {
  final _ = await io.Process.run(
    'flutter',
    ['pub', 'upgrade', '--major-versions'],
  );
}
