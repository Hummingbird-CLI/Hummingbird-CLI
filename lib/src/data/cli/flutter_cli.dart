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

  /// Creates a directory at the given [path].
  /// If the directory already exists, this method does nothing.
  Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Creates a file at the given [path] with the optional [content].
  /// If the file already exists, it will be overwritten.
  Future<void> createFile(String path, {String? content}) async {
    final file = File(path);
    await file.create(recursive: true); // Ensure the directory structure exists
    if (content != null) {
      await file.writeAsString(content);
    }
  }

  // Future<void> addDependencies({
  //   required String projectName,
  //   required List<String> dependencies,
  //   required List<String> devDependencies,
  //   required Logger logger,
  // }) async {
  //   final originalDirectory = Directory.current;
  //   Directory.current = projectName;
  //   for (final dependency in dependencies) {
  //     await _commandLine.run(
  //       command: 'flutter',
  //       args: [
  //         'pub',
  //         'add',
  //         dependency,
  //       ],
  //       logger: logger,
  //     );
  //   }

  //   for (final dependency in devDependencies) {
  //     await _commandLine.run(
  //       command: 'flutter',
  //       args: [
  //         'pub',
  //         'add',
  //         '--dev',
  //         dependency,
  //       ],
  //       logger: logger,
  //     );
  //   }
  //   Directory.current = originalDirectory;
  // }

  /// Adds dependencies to the pubspec.yaml of a Flutter project.
  Future<void> addDependencies({
    required String projectName,
    required Map<String, String> dependencies,
    required Map<String, String> devDependencies,
    required Logger logger,
  }) async {
    final progress = logger.progress('Adding dependencies to $projectName...');
    try {
      final pubspecPath = '$projectName/pubspec.yaml';

      final updatedPubspecContents = _updatePubspecContents(
        pubspecContents: await File(pubspecPath).readAsString(),
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
