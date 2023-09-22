import 'dart:io';

import 'package:hummingbird_cli/src/data/cli/command_line.dart';
import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCommandLine extends Mock implements CommandLine {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('FlutterCli', () {
    late CommandLine commandLine;
    late Logger logger;
    late FlutterCli flutterCli;

    setUp(() {
      commandLine = _MockCommandLine();
      logger = _MockLogger();
      flutterCli = FlutterCli(
        commandLine: commandLine,
      );
    });

    test('can be instantiated', () {
      expect(flutterCli, isNotNull);
    });

    test('isInstalled returns true on success', () async {
      when(
        () => commandLine.run(
          command: any(named: 'command'),
          args: any(named: 'args'),
          logger: logger,
        ),
      ).thenAnswer((_) async => ProcessResult(0, 0, null, null));

      final isInstalled = await flutterCli.isInstalled(logger: logger);
      expect(isInstalled, true);
    });

    test('isInstalled returns false on failure', () async {
      when(
        () => commandLine.run(
          command: any(named: 'command'),
          args: any(named: 'args'),
          logger: logger,
        ),
      ).thenThrow(const ProcessException('executable', []));

      final isInstalled = await flutterCli.isInstalled(logger: logger);
      expect(isInstalled, false);
    });

    test('createProject calls command line', () async {
      when(
        () => commandLine.run(
          command: any(named: 'command'),
          args: any(named: 'args'),
          logger: logger,
        ),
      ).thenAnswer((_) async => ProcessResult(0, 0, null, null));

      await flutterCli.createProject(
        name: 'my_project',
        org: 'com.hummingbird',
        logger: logger,
      );

      verify(
        () => commandLine.run(
          command: 'flutter',
          args: [
            'create',
            '--org',
            'com.hummingbird',
            'my_project',
          ],
          logger: logger,
        ),
      ).called(1);
    });
  });
}
