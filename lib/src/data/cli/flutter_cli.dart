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

  /// Adds dependencies to the pubspec.yaml of a Flutter project.
  Future<void> addDependencies({
    required String projectName,
    required Map<String, String> dependencies,
    required Map<String, String> devDependencies,
    required Logger logger,
  }) async {
    // ignore: lines_longer_than_80_chars
    // TODO(benlrichards): We need to determine a way to dynamically update the versions for the dependencies
    final progress = logger.progress('Adding dependencies to $projectName...');
    try {
      final pubspecPath = '$projectName/pubspec.yaml';
      final pubspecContents = await File(pubspecPath).readAsString();

      final updatedPubspecContents = _updatePubspecContents(
        pubspecContents: pubspecContents,
        dependencies: dependencies,
        devDependencies: devDependencies,
      );

      await File(pubspecPath).writeAsString(updatedPubspecContents);
      progress.complete('Added dependencies to $projectName');
    } catch (e) {
      progress.fail('Failed to add dependencies to $projectName');
      rethrow;
    }
  }

  String _updatePubspecContents({
    required String pubspecContents,
    required Map<String, String> dependencies,
    required Map<String, String> devDependencies,
  }) {
    var newContents = pubspecContents;

    // Check and add dependencies
    if (dependencies.isNotEmpty) {
      final dependenciesString = dependencies.entries
          .map((entry) => '  ${entry.key}: ${entry.value}')
          .join('\n');
      if (newContents.contains('dependencies:\n')) {
        newContents = newContents.replaceFirst(
          RegExp('(dependencies:\n)'),
          'dependencies:\n$dependenciesString\n',
        );
      } else {
        newContents += '\ndependencies:\n$dependenciesString\n';
      }
    }

    // Check and add dev_dependencies
    if (devDependencies.isNotEmpty) {
      final devDependenciesString = devDependencies.entries
          .map((entry) => '  ${entry.key}: ${entry.value}')
          .join('\n');
      if (newContents.contains('dev_dependencies:\n')) {
        newContents = newContents.replaceFirst(
          RegExp('(dev_dependencies:\n)'),
          'dev_dependencies:\n$devDependenciesString\n',
        );
      } else {
        newContents += '\ndev_dependencies:\n$devDependenciesString\n';
      }
    }

    return newContents;
  }
}
