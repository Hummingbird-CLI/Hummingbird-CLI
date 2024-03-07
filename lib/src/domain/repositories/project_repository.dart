import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:hummingbird_cli/src/domain/models/flavor.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:hummingbird_cli/src/extensions/string_extensions.dart';
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
    final appName = name.titleCaseFromSnakeCase();
    final org = logger.prompt(
      'What is your organization name?',
      defaultValue: 'com.hummingbird',
    );
    final stateManagement = logger.chooseOne<StateManagement>(
      'Choose a state management solution:',
      choices: [
        StateManagement.bloc,
      ],
      display: (choice) {
        switch (choice) {
          case StateManagement.bloc:
            return 'BLoC';
        }
      },
    );

    List<Flavor>? flavors = [];
    var addMore = logger.confirm('Do you want to add flavors?');

    while (addMore) {
      final flavorName = logger.prompt('Enter a flavor name:');
      final flavorSuffix = logger.prompt(
        'Enter a flavor suffix (e.g. stg for staging):',
      );
      flavors.add(Flavor(name: flavorName, suffix: flavorSuffix));
      addMore = logger.confirm('Do you want to add another flavor?');
    }
    if (flavors.isEmpty) {
      flavors = null;
    }

    bool? useHydratedBloc;
    bool? useReplayBloc;

    if (stateManagement == StateManagement.bloc) {
      useHydratedBloc = logger.confirm(
        'Do you want to use hydrated_bloc?',
      );
      useReplayBloc = logger.confirm(
        'Do you want to use replay_bloc?',
      );
    }

    final architecture = logger.chooseOne<Architecture>(
      'Choose a project architecture:',
      choices: [
        Architecture.clean,
        Architecture.featureBased,
      ],
      display: (choice) {
        switch (choice) {
          case Architecture.clean:
            return 'Clean';
          case Architecture.featureBased:
            return 'Feature-Based';
        }
      },
    );
    return Project(
      name: name,
      appName: appName,
      org: org,
      flavors: flavors,
      stateManagement: stateManagement,
      useHydratedBloc: useHydratedBloc,
      useReplayBloc: useReplayBloc,
      architecture: architecture,
    );
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

    progress.complete('Created project ${project.name}');
    return const Right(null);
  }
}
