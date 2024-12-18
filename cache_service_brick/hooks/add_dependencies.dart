import 'dart:io' as io;

import 'package:mason/mason.dart';

import 'context_variables.dart';

Future<void> addDependencies(HookContext context) async {
  final dependencies = [
    if (context.hooks) 'hooks_riverpod' else 'flutter_riverpod',
    if (context.hooks) 'flutter_hooks',
    if (context.generation) 'riverpod_annotation',
    'meta',
    'shared_preferences',
  ];

  final devDependencies = [
    if (context.generation) 'build_runner',
    if (context.generation) 'riverpod_generator',
    'mocktail',
    'riverpod_lint',
  ];

  final _ = await io.Process.run(
    'flutter',
    ['pub', 'add', ...dependencies, ...devDependencies.map((e) => 'dev:$e')],
  );
}
