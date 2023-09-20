import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:hummingbird_cli/src/domain/repositories/project_repository.dart';
import 'package:mason_logger/mason_logger.dart';

class CreateProjectCommand extends Command<int> {
  CreateProjectCommand({
    required Logger logger,
    required ProjectRepository projectRepository,
  })  : _logger = logger,
        _projectRepository = projectRepository;

  final Logger _logger;
  final ProjectRepository _projectRepository;

  @override
  String get description => 'Creates a new Flutter project.';

  @override
  String get name => 'create:project';

  @override
  FutureOr<int>? run() {
    final project = _projectRepository.gatherProjectInfo(logger: _logger);
    _projectRepository.createProject(project: project, logger: _logger);
    return ExitCode.success.code;
  }
}
