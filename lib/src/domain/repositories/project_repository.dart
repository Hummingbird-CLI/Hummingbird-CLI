import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template project_repository}
/// A repository for interacting with Flutter projects.
/// {@endtemplate}
class ProjectRepository {
  /// {@macro project_repository}
  ProjectRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

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
    final stateManagement = logger.chooseOne(
      'Choose a state management solution:',
      choices: ['BLoC', 'Provider', 'Riverpod'],
      defaultValue: 'BLoC',
    );
    return Project(name: name, org: org, stateManagement: stateManagement);
  }

  /// Uses the settings in [project] to create a Flutter project.
  Future<Either<CommandError, void>> createProject({
    required Project project,
    required Logger logger,
  }) async {
    final progress = logger.progress('Creating project ${project.name}...');

    // Check if Flutter is installed
    if (!(await _flutterCli.isInstalled(logger: logger))) {
      progress.fail('Flutter is not installed');
      return Left(CommandError('Flutter is not installed'));
    }

    // Create Flutter project
    try {
      await _flutterCli.createProject(
        name: project.name,
        org: project.org,
        logger: logger,
      );
    } catch (e) {
      progress.fail('Failed to create project ${project.name}');
      return Left(CommandError('Failed to create project ${project.name}'));
    }

    // Scaffold project based on state management choice
    switch (project.stateManagement) {
      case 'BLoC':
        await scaffoldBlocProject(project, logger);

      case 'Provider':
        // Scaffold project with Provider
        break;
      case 'Riverpod':
        // Scaffold project with Riverpod
        break;
    }

    progress.complete('Created project ${project.name}');
    return const Right(null);
  }

  Future<void> scaffoldBlocProject(Project project, Logger logger) async {
    logger.info('Scaffolding BLoC project...');

    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: {
        'flutter_bloc': '^8.1.3',
        'bloc': '^8.1.2',
      },
      devDependencies: {
        'bloc_test': '^9.1.5',
      },
      logger: logger,
    );
    // TODO (benlrichards): Dynamically generate the BLoC files and structure based on the architecture chosen.
    // Generate BLoC files and structure
    // Any other BLoC specific setup
  }

  Future<void> scaffoldProviderProject(Project project, Logger logger) async {
    // Example steps for scaffolding a Provider project
    logger.info('Scaffolding Provider project...');
    // Add Provider dependencies to pubspec.yaml
    // Generate Provider files and structure
    // Any other Provider specific setup
  }

  Future<void> scaffoldRiverpodProject(Project project, Logger logger) async {
    // Example steps for scaffolding a Riverpod project
    logger.info('Scaffolding Riverpod project...');
    // Add Riverpod dependencies to pubspec.yaml
    // Generate Riverpod files and structure
    // Any other Riverpod specific setup
  }
}
