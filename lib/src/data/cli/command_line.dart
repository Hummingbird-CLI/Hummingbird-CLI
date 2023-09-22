import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

/// Allows for tunning commands from the command line
class CommandLine {
  /// Runs the [command] with the given [args]
  Future<ProcessResult> run({
    required String command,
    required List<String> args,
    required Logger logger,
  }) async {
    logger.detail('Running command: $command ${args.join(' ')}');
    final result = await Process.run(command, args, runInShell: true);
    logger
      ..detail('Command result: ${result.stdout}')
      ..detail('Command error: ${result.stderr}');

    if (result.exitCode != 0) {
      logger.err('Command failed with exit code ${result.exitCode}');
      throw ProcessException(
        command,
        args,
        result.stderr.toString(),
        result.exitCode,
      );
    }

    return result;
  }
}
