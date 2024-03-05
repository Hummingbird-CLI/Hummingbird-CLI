import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

/// A repository that manages the dependencies for a Flutter project.
///
/// This repository is responsible for adding, updating, and removing
/// dependencies in a project's pubspec.yaml file.
class DependencyRepository {
  /// {@macro project_repository}
  DependencyRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

  /// Adds state management dependencies to the given [project].
  ///
  /// This method determines the state management solution specified in
  /// [project] and adds the necessary dependencies for it. It also adds
  /// file generation dependencies common to all state management solutions.
  ///
  /// [project]: The project to which dependencies are added.
  /// [logger]: Used to log the progress of adding dependencies.
  Future<void> addStateManagementDependencies({
    required Project project,
    required Logger logger,
  }) async {
    await _addFileGenerationDependencies(project: project, logger: logger);
    switch (project.stateManagement) {
      case StateManagement.bloc:
        await _addBlocDependencies(project: project, logger: logger);
      case StateManagement.provider:
        await _addProviderDependencies(project: project, logger: logger);
      case StateManagement.riverpod:
        await _addRiverpodDependencies(project: project, logger: logger);
    }
  }

  Future<void> _addFileGenerationDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding file generation dependencies...');

    final fileGenerationDependencies = [
      'freezed',
      'freezed_annotation',
      'json_annotation',
      'json_serializable',
      'build_runner',
    ];

    final fileGenerationDevDependencies = [
      'build_runner',
    ];

    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: _mapDependenciesWithVersions(fileGenerationDependencies),
      devDependencies:
          _mapDependenciesWithVersions(fileGenerationDevDependencies),
      logger: logger,
    );
  }

  Future<void> _addBlocDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding BLoC dependencies...');

    final dependencies = [
      'flutter_bloc',
      'bloc',
    ];
    final devDependencies = ['bloc_test'];

    if (project.useHydratedBloc ?? false) {
      dependencies.add('hydrated_bloc');
      devDependencies.add('mocktail');
    }

    if (project.useReplayBloc ?? false) {
      dependencies.add('replay_bloc');
      devDependencies.add('mocktail');
    }

    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: _mapDependenciesWithVersions(dependencies),
      devDependencies: _mapDependenciesWithVersions(devDependencies),
      logger: logger,
    );
  }

  Future<void> _addProviderDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding Provider dependencies...');
    final dependencies = [
      'provider',
    ];
    final devDependencies = [
      'mocktail',
    ];
    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: _mapDependenciesWithVersions(dependencies),
      devDependencies: _mapDependenciesWithVersions(devDependencies),
      logger: logger,
    );
  }

  Future<void> _addRiverpodDependencies({
    required Project project,
    required Logger logger,
  }) async {
    logger.info('Adding Riverpod dependencies...');
    final dependencies = [
      'flutter_riverpod',
    ];

    final devDependencies = [
      'mocktail',
    ];

    await _flutterCli.addDependencies(
      projectName: project.name,
      dependencies: _mapDependenciesWithVersions(dependencies),
      devDependencies: _mapDependenciesWithVersions(devDependencies),
      logger: logger,
    );
  }

  Map<String, String> _mapDependenciesWithVersions(List<String> dependencies) {
    final depWithVersions = <String, String>{};

    for (final dep in dependencies) {
      depWithVersions[dep] = _dependencies[dep]!;
    }

    return depWithVersions;
  }

  Map<String, String> get _dependencies => {
        'build_runner': '^2.4.4',
        'bloc_test': '^9.1.5',
        'bloc': '^8.1.2',
        'flutter_bloc': '^8.1.3',
        'freezed': '^2.4.7',
        'mocktail': '^1.0.0',
        'freezed_annotation': '^2.4.1',
        'json_annotation': '^4.8.1',
        'json_serializable': '^6.7.1',
        'provider': '^6.1.2',
        'flutter_riverpod': '^2.4.10',
        'hydrated_bloc': '^9.1.4',
        'replay_bloc': '^0.2.6',
      };
}
