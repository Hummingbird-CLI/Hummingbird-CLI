import 'dart:io';

import 'package:hummingbird_cli/src/data/cli/command_line.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('CommandLine', () {
    late CommandLine commandLine;
    late Logger logger;

    setUp(() {
      commandLine = CommandLine();
      logger = _MockLogger();
    });

    test('can be instantiated', () {
      expect(commandLine, isNotNull);
    });

    test('run returns process result', () async {
      final result = await commandLine.run(
        command: 'echo',
        args: ['hello'],
        logger: logger,
      );
      expect(result.exitCode, 0);
      expect(result.stdout, 'hello\n');
    });

    test('run throws on failure', () async {
      expect(
        () async => commandLine.run(
          command: 'false',
          args: [],
          logger: logger,
        ),
        throwsA(isA<ProcessException>()),
      );
    });
  });
}
