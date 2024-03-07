import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:xcodeproj/xcodeproj.dart';

class FlavorsRepository {
  /// {@macro project_repository}
  FlavorsRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

  Future<Either<CommandError, void>> setUpFlavors({
    required Project project,
    required Logger logger,
  }) async {
    final progress =
        logger.progress('Setting up flavors for ${project.name}...');

    // Check if there are any flavors to set up
    if (project.flavors == null || project.flavors!.isEmpty) {
      progress.complete('No flavors to set up for ${project.name}');
      return const Right(null);
    }

    try {
      // For Android:
      // 1. Modify android/app/build.gradle to add a new productFlavor.
      await _addFlavorsToBuildGradle(project: project, logger: logger);
      // 2. Adjust settings.gradle if necessary.
      // 3. Any other Android-specific configurations.

      // For iOS:
      // 1. Use xcodeproj or a similar tool to create new configurations and schemes for the flavor.
      _addIOSConfigurationsAndSchemes(project: project, logger: logger);
      // 2. Adjust Info.plist files as necessary for each flavor.
      // 3. Any other iOS-specific configurations.

      // Common:
      // 1. Create environment-specific files for Flutter (e.g., .env.production, .env.development).
      _createVSCodeLaunchConfigurationsForFlavors(
        project: project,
        logger: logger,
      );
      // 2. Update any Flutter Dart code to recognize and use these environments/flavors.
      await _createMainDartFilesForFlavors(project: project, logger: logger);

      // TODO: Delete the original main.dart file

      progress.complete('Successfully set up flavors for ${project.name}');
      return const Right(null);
    } catch (e) {
      progress.fail('Failed to set up flavors for ${project.name}');
      return Left(
        CommandError('Failed to set up flavors for ${project.name}: $e'),
      );
    }
  }

  Future<void> _createMainDartFilesForFlavors({
    required Project project,
    required Logger logger,
  }) async {
    final basePath = '${project.name}/lib';
    final appFilePath = '$basePath/app.dart';

    // Create a generic app.dart file
    await _flutterCli.createFile(
      appFilePath,
      content: _appFileContent(project),
    );
    logger.info('Created app.dart file.');

    // Create main.dart file for each flavor
    for (final flavor in project.flavors!) {
      final flavorMainFilePath = '$basePath/main_${flavor.name}.dart';
      await _flutterCli.createFile(
        flavorMainFilePath,
        content: _flavorMainFileContent(flavor.name, project.name),
      );
      logger.info('Created main_${flavor.name}.dart file.');
    }
  }

  String _appFileContent(Project project) {
    return '''
import 'package:flutter/material.dart';
import 'package:${project.name}/presentation/counter/views/counter_page.dart'; // Adjust this import as necessary
class App extends StatelessWidget{
  const App({Key? key}) : super(key: key);
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: '${project.appName}',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const CounterPage(), // Adjust this as necessary
  );
}}
''';
  }

  String _flavorMainFileContent(String flavorName, String projectName) {
    return '''
import 'package:flutter/material.dart';
import 'package:$projectName/app.dart';

void main() {
  // Initialize flavor-specific settings here if necessary
  runApp(App());
}
''';
  }

  Future<void> _createVSCodeLaunchConfigurationsForFlavors({
    required Project project,
    required Logger logger,
  }) async {
    final launchConfigurations = {
      'version': '0.2.0',
      'configurations': project.flavors?.map((flavor) {
            return {
              'name': 'Launch ${flavor.name}',
              'request': 'launch',
              'type': 'dart',
              'program': 'lib/main_${flavor.name}.dart',
              'args': [
                '--flavor',
                flavor.name,
                '--target',
                'lib/main_${flavor.name}.dart',
              ],
            };
          }).toList() ??
          [],
    };

    final launchConfigPath = '${project.name}/.vscode/launch.json';
    final file = File(launchConfigPath);
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(launchConfigurations));
    logger.info('VSCode launch configurations created for flavors.');
  }

  void _addIOSConfigurationsAndSchemes({
    required Project project,
    required Logger logger,
  }) {
    final xCodeProjectPath = '${project.name}/ios/Runner.xcodeproj';
    final xCodeProject = XCodeProj(xCodeProjectPath);

    for (final target in xCodeProject.targets) {
      logger.info('Adding configurations for ${target.name}');
      final releaseConfig = target.buildConfigurationList!.getByName('Release');
      final debugConfig = target.buildConfigurationList!.getByName('Debug');
      final profileConfig = target.buildConfigurationList!.getByName('Profile');
      for (final flavor in project.flavors!) {
        logger.info(
          'Adding configuration for ${target.name}: Release-${flavor.name}',
        );
        target.buildConfigurationList!.addBuildConfiguration(
          'Release-${flavor.name}',
          baseConfigurationReference: releaseConfig!.baseConfigurationReference,
          buildSettings: {
            'PRODUCT_BUNDLE_IDENTIFIER':
                '${project.org}.${project.name}${flavor.suffix != null ? '.${flavor.suffix}' : ''}',
          },
        );
        logger.info(
          'Adding configuration for ${target.name}: Debug-${flavor.name}',
        );
        target.buildConfigurationList!.addBuildConfiguration(
          'Debug-${flavor.name}',
          baseConfigurationReference: debugConfig!.baseConfigurationReference,
          buildSettings: {
            'PRODUCT_BUNDLE_IDENTIFIER':
                '${project.org}.${project.name}${flavor.suffix != null ? '.${flavor.suffix}' : ''}',
          },
        );
        logger.info(
          'Adding configuration for ${target.name}: Profile-${flavor.name}',
        );
        target.buildConfigurationList!.addBuildConfiguration(
          'Profile-${flavor.name}',
          baseConfigurationReference: profileConfig!.baseConfigurationReference,
          buildSettings: {
            'PRODUCT_BUNDLE_IDENTIFIER':
                '${project.org}.${project.name}${flavor.suffix != null ? '.${flavor.suffix}' : ''}',
          },
        );
      }

      logger.info(
        'Target ${target.name} Configuration names: ${target.buildConfigurationList!.buildConfigurations.map((config) => config.name).join(', ')}',
      );

      target.buildConfigurationList!.removeBuildConfiguration('Release');
      target.buildConfigurationList!.removeBuildConfiguration('Debug');
      target.buildConfigurationList!.removeBuildConfiguration('Profile');
    }

    //   for (final target in xCodeProject.targets) {
    //     for (final config
    //         in target.buildConfigurationList!.buildConfigurations) {
    //       final configReference = config.baseConfigurationReference;
    //       target.buildConfigurationList!.addBuildConfiguration(
    //         '${config.name}-${flavor.name}',
    //         baseConfigurationReference: configReference,
    //       );
    //     }
    //   }
    // }
    xCodeProject.save();
  }

  Future<void> _addFlavorsToBuildGradle({
    required Project project,
    required Logger logger,
  }) async {
    final gradleFilePath = '${project.name}/android/app/build.gradle';
    final gradleFile = File(gradleFilePath);
    if (!gradleFile.existsSync()) {
      throw Exception('build.gradle not found at $gradleFilePath');
    }
    final lines = gradleFile.readAsLinesSync();
    final flavorConfigIndex =
        lines.indexWhere((line) => line.contains('flavorDimensions'));
    if (flavorConfigIndex != -1) {
      // Assuming flavor configuration already exists, skip or handle accordingly
      logger.info('Product flavors already configured in build.gradle');
      return;
    }
    final defaultConfigIndex =
        lines.indexWhere((line) => line.contains('defaultConfig {'));
    if (defaultConfigIndex == -1) {
      throw Exception('defaultConfig block not found in build.gradle');
    }
    final flavorConfigLines = [
      '    flavorDimensions "default"',
      '    productFlavors {',
      for (final flavor in project.flavors!) ...{
        '        ${flavor.name} {',
        '            dimension "default"',
        '            applicationIdSuffix "${flavor.suffix ?? ''}"',
        '            manifestPlaceholders = [appName: "${flavor.suffix != null ? '[${flavor.suffix!.toUpperCase()}] ' : ''}${project.appName}"]',
        '        }',
      },
      '    }',
    ];
    lines.insertAll(defaultConfigIndex + 1, flavorConfigLines);
    gradleFile.writeAsStringSync(lines.join('\n'));
  }
}
