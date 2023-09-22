import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/command_runner.dart';
import 'package:hummingbird_cli/src/commands/create/commands/create_app_command.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:hummingbird_cli/src/domain/repositories/project_repository.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockProjectRepository extends Mock implements ProjectRepository {}

class _MockProgress extends Mock implements Progress {}

class _MockPubUpdater extends Mock implements PubUpdater {}

void main() {
  group('CreateAppCommand', () {
    late ProjectRepository projectRepository;
    late PubUpdater pubUpdater;
    late Logger logger;
    late HummingbirdCliCommandRunner commandRunner;

    // Useful values for testing
    final validProject = Project(name: 'example', org: 'com.test');

    setUp(() {
      final progress = _MockProgress();
      final progressLogs = <String>[];

      projectRepository = _MockProjectRepository();
      pubUpdater = _MockPubUpdater();
      logger = _MockLogger();
      commandRunner = HummingbirdCliCommandRunner(
        logger: logger,
        pubUpdater: pubUpdater,
        projectRepository: projectRepository,
      );

      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
      when(() => logger.prompt(any(), defaultValue: any(named: 'defaultValue')))
          .thenReturn('example');
    });

    test('can be instantiated', () {
      final command = CreateAppCommand(
        logger: logger,
        projectRepository: projectRepository,
      );
      expect(command, isNotNull);
      expect(command.description, 'Creates a new Flutter app project.');
      expect(command.name, 'app');
    });

    test('calls project repository to gather project info', () async {
      when(() => projectRepository.gatherProjectInfo(logger: logger))
          .thenReturn(validProject);

      when(
        () => projectRepository.createProject(
          project: validProject,
          logger: logger,
        ),
      ).thenAnswer((_) async => const Right(null));

      final command = CreateAppCommand(
        logger: logger,
        projectRepository: projectRepository,
      );
      final result = await commandRunner.run(['create', command.name]);

      expect(result, ExitCode.success.code);
      verify(() => projectRepository.gatherProjectInfo(logger: logger))
          .called(1);
      verify(
        () => projectRepository.createProject(
          project: validProject,
          logger: logger,
        ),
      ).called(1);
    });
  });
}
