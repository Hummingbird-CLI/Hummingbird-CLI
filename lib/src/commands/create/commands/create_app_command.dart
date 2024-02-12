import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:hummingbird_cli/src/domain/repositories/dependency_repository.dart';
import 'package:hummingbird_cli/src/domain/repositories/project_repository.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template create_project_command}
/// `hummingbird create app` command which creates a new Flutter project.
/// {@endtemplate}
class CreateAppCommand extends Command<int> {
  /// {@macro create_project_command}
  CreateAppCommand({
    required Logger logger,
    required ProjectRepository projectRepository,
    required DependencyRepository dependencyRespository,
  })  : _logger = logger,
        _projectRepository = projectRepository,
        _dependencyRespository = dependencyRespository;

  final Logger _logger;
  final ProjectRepository _projectRepository;
  final DependencyRepository _dependencyRespository;

  @override
  String get description => 'Creates a new Flutter app project.';

  @override
  String get name => 'app';

  @override
  FutureOr<int>? run() async {
    final project = _projectRepository.gatherProjectInfo(logger: _logger);
    await _projectRepository.createProject(project: project, logger: _logger);
    await _dependencyRespository.addStateManagementDependencies(
      project: project,
      logger: _logger,
    );
    return ExitCode.success.code;
  }
}
