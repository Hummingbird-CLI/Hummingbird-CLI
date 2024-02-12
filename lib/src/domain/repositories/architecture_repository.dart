import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

class ArchitectureRepository {
  /// {@macro project_repository}
  ArchitectureRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

  Future<void> scaffoldArchitecture({
    required Project project,
    required Logger logger,
  }) async {}

  Future<void> _scaffoldBlocProject(Project project, Logger logger) async {
    logger.info('Scaffolding BLoC project...');

    // Generate BLoC files and structure considering hydrated_bloc and replay_bloc
  }

  Future<void> _scaffoldProviderProject(Project project, Logger logger) async {
    // Example steps for scaffolding a Provider project
    logger.info('Scaffolding Provider project...');
    // Add Provider dependencies to pubspec.yaml
    // Generate Provider files and structure
    // Any other Provider specific setup
  }

  Future<void> _scaffoldRiverpodProject(Project project, Logger logger) async {
    // Example steps for scaffolding a Riverpod project
    logger.info('Scaffolding Riverpod project...');
    // Add Riverpod dependencies to pubspec.yaml
    // Generate Riverpod files and structure
    // Any other Riverpod specific setup
  }
}
