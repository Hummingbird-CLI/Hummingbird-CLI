import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

class ProjectRepository {
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

  Either<CommandError, void> createProject({
    required Project project,
    required Logger logger,
  }) {
    final progress = logger.progress('Creating project ${project.name}...');

    //TODO: run flutter create command
    
    progress.complete('Created project ${project.name}');
    return const Right(null);
  }
}
