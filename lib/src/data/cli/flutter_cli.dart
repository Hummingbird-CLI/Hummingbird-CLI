import 'dart:io';

import 'package:hummingbird_cli/src/data/cli/command_line.dart';
import 'package:mason_logger/mason_logger.dart';

/// Allows to run Flutter CLI commands.
class FlutterCli {

  /// Checks if Flutter is installed.
  static Future<bool> isInstalled({required Logger logger}) async {
    try {
      await CommandLine.run(
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
  static Future<void> createProject({
    required String name,
    required String org,
    required Logger logger,
  }) async {
    await CommandLine.run(
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
