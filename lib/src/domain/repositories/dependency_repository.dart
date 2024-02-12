import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

class DependencyRepository {
  /// {@macro project_repository}
  DependencyRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

  Future<void> addStateManagementDependencies({
    required Project project,
    required Logger logger,
  }) async {
    switch (project.stateManagement) {
      case StateManagement.bloc:
        await _addBlocDependencies(project: project, logger: logger);
      case StateManagement.provider:
        await _addProviderDependencies(project: project, logger: logger);
      case StateManagement.riverpod:
        await _addRiverpodDependencies(project: project, logger: logger);
    }
  }

  Future<void> _addBlocDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding BLoC dependencies...');
    final dependencies = {
      'flutter_bloc': '^8.1.3',
      'bloc': '^8.1.2',
    };
    final devDependencies = {
      'bloc_test': '^9.1.5',
    };

    if (project.useHydratedBloc ?? false) {
      dependencies['hydrated_bloc'] = '^8.0.0';
      devDependencies['mocktail'] = '^0.2.0';
    }

    if (project.useReplayBloc ?? false) {
      dependencies['replay_bloc'] = '^8.0.0';
    }

    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: dependencies,
      devDependencies: devDependencies,
      logger: logger,
    );
  }

  Future<void> _addProviderDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding Provider dependencies...');
    //TODO(benlrichards): Add Provider dependencies
  }

  Future<void> _addRiverpodDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding Riverpod dependencies...');
    //TODO(benlrichards): Add Riverpod dependencies
  }
}
