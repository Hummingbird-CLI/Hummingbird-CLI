import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:hummingbird_cli/src/domain/repositories/project_repository.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFlutterCli extends Mock implements FlutterCli {}

class _MockLogger extends Mock implements Logger {}

class _MockProgress extends Mock implements Progress {}

void main() {
  group('ProjectRepository', () {
    late FlutterCli flutterCli;
    late ProjectRepository projectRepository;
    late Logger logger;

    setUp(() {
      final progress = _MockProgress();
      final progressLogs = <String>[];

      flutterCli = _MockFlutterCli();
      logger = _MockLogger();
      projectRepository = ProjectRepository(
        flutterCli: flutterCli,
      );

      when(() => progress.complete(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => progress.fail(any())).thenAnswer((_) {
        final message = _.positionalArguments.elementAt(0) as String?;
        if (message != null) progressLogs.add(message);
      });
      when(() => logger.progress(any())).thenReturn(progress);
    });

    test('can be instantiated', () {
      expect(projectRepository, isNotNull);
    });

    test('can gather info', () {
      when(
        () => logger.prompt(
          'What is the name of your project?',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn('my_project');
      when(
        () => logger.prompt(
          'What is your organization name?',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn('com.hummingbird');

      final project = projectRepository.gatherProjectInfo(logger: logger);
      expect(project, isNotNull);
      expect(project.name, 'my_project');
      expect(project.org, 'com.hummingbird');
    });

    test('can create a project', () async {
      when(() => flutterCli.isInstalled(logger: logger)).thenAnswer(
        (_) async => true,
      );
      when(
        () => flutterCli.createProject(
          name: any(named: 'name'),
          org: any(named: 'org'),
          logger: logger,
        ),
      ).thenAnswer((_) async {});

      final project = Project(name: 'example', org: 'com.test');
      final result = await projectRepository.createProject(
        project: project,
        logger: logger,
      );
      expect(result.isRight(), isTrue);
    });

    test('can handle Flutter not being installed', () async {
      when(() => flutterCli.isInstalled(logger: logger)).thenAnswer(
        (_) async => false,
      );

      final project = Project(name: 'example', org: 'com.test');
      final result = await projectRepository.createProject(
        project: project,
        logger: logger,
      );
      expect(result.isLeft(), isTrue);
    });

    test('can handle error during project creation', () async {
      when(() => flutterCli.isInstalled(logger: logger)).thenAnswer(
        (_) async => true,
      );
      when(
        () => flutterCli.createProject(
          name: any(named: 'name'),
          org: any(named: 'org'),
          logger: logger,
        ),
      ).thenThrow(Exception());

      final project = Project(name: 'example', org: 'com.test');
      final result = await projectRepository.createProject(
        project: project,
        logger: logger,
      );
      expect(result.isLeft(), isTrue);
    });
  });
}
