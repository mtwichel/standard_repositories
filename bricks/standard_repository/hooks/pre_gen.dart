import 'package:mason/mason.dart';
import 'package:pluralize/pluralize.dart';

Future<void> run(HookContext context) async {
  final pluralize = Pluralize();
  context.vars['name_plural'] =
      pluralize.plural(context.vars['name'] as String);
  context.vars['name_single'] =
      pluralize.singular(context.vars['name'] as String);
  context.vars.remove('name');
}
