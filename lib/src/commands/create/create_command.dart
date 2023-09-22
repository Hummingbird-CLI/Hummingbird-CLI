import 'package:args/command_runner.dart';
import 'package:hummingbird_cli/src/commands/create/commands/create_app_command.dart';
import 'package:hummingbird_cli/src/domain/repositories/project_repository.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template create_command}
/// A collection of creation commands. This is the root command.
/// {@endtemplate}
class CreateCommand extends Command<int> {
  /// {@macro create_command}
  CreateCommand({
    required Logger logger,
    required ProjectRepository projectRepository,
  }) {
    addSubcommand(
      CreateAppCommand(
        logger: logger,
        projectRepository: projectRepository,
      ),
    );
  }

  @override
  String get description => 'Creates a new project.';

  @override
  String get name => 'create';
}
