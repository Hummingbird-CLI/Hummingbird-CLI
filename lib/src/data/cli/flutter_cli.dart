import 'dart:io';

import 'package:hummingbird_cli/src/data/cli/command_line.dart';
import 'package:mason_logger/mason_logger.dart';

/// {@template flutter_cli}
/// Allows for running Flutter commands from the command line.
/// {@endtemplate}
class FlutterCli {
  /// {@macro flutter_cli}
  FlutterCli({
    CommandLine? commandLine,
  }) : _commandLine = commandLine ?? CommandLine();

  final CommandLine _commandLine;

  /// Checks if Flutter is installed.
  Future<bool> isInstalled({required Logger logger}) async {
    try {
      await _commandLine.run(
        command: 'flutter',
        args: ['--version'],
        logger: logger,
      );
      return true;
    } on ProcessException {
      return false;
    }
  }

  /// Creates a Flutter project.
  Future<void> createProject({
    required String name,
    required String org,
    required Logger logger,
  }) async {
    await _commandLine.run(
      command: 'flutter',
      args: [
        'create',
        '--org',
        org,
        name,
      ],
      logger: logger,
    );
  }
}
