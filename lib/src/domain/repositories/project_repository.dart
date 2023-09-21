import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

/// A repository for interacting with Flutter projects.
class ProjectRepository {

  /// Gathers project information.
  /// Returns a [Project] with the gathered information.
  Project gatherProjectInfo({required Logger logger}) {
    final name = logger.prompt(
      'What is the name of your project?',
      defaultValue: 'my_project',
    );
    final org = logger.prompt(
      'What is your organization name?',
      defaultValue: 'com.hummingbird',
    );
    return Project(name: name, org: org);
  }

  /// Uses the settings in [project] to create a Flutter project.
  Future<Either<CommandError, void>> createProject({
    required Project project,
    required Logger logger,
  }) async {
    final progress = logger.progress('Creating project ${project.name}...');

    // Check if Flutter is installed
    if (!(await FlutterCli.isInstalled(logger: logger))) {
      progress.fail('Flutter is not installed');
      return Left(CommandError('Flutter is not installed'));
    }

    // Create Flutter project
    try{
      await FlutterCli.createProject(
        name: project.name,
        org: project.org,
        logger: logger,
      );
    }catch(e){
      progress.fail('Failed to create project ${project.name}');
      return Left(CommandError('Failed to create project ${project.name}'));
    }

    progress.complete('Created project ${project.name}');
    return const Right(null);
  }
}
