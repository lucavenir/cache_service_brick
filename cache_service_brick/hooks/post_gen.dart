import 'package:mason/mason.dart';

import 'add_dependencies.dart';
import 'execute_and_log.dart';
import 'upgrade_dependencies.dart';

Future<void> run(HookContext context) async {
  await executeLogAndWait(
    context: context,
    cb: addDependencies,
    message: 'Adding dependencies..',
  );

  await executeLogAndWait(
    context: context,
    cb: upgradeDependencies,
    message: 'Upgrading dependencies..',
  );
}
