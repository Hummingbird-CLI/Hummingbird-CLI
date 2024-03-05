import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

/// A repository responsible for handling architecture-related operations.
class ArchitectureRepository {
  /// Creates an [ArchitectureRepository] with an optional [FlutterCli].
  ///
  ArchitectureRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

  /// Scaffolds the architecture for a given [project] based on its state
  /// management solution, logging progress through [logger].
  Future<void> scaffoldArchitecture({
    required Project project,
    required Logger logger,
  }) async {
    switch (project.stateManagement) {
      case StateManagement.bloc:
        await _scaffoldBlocProject(project, logger);
      case StateManagement.provider:
        await _scaffoldProviderProject(project, logger);
      case StateManagement.riverpod:
        await _scaffoldRiverpodProject(project, logger);
    }
  }

  /// Scaffolds a BLoC project based on the [project]'s architecture,
  /// logging progress through [logger].
  Future<void> _scaffoldBlocProject(Project project, Logger logger) async {
    switch (project.architecture) {
      case Architecture.featureBased:
        await _scaffoldBlocFeatureProject(project, logger);
      case Architecture.clean:
        await _scaffoldBlocCleanProject(project, logger);
    }
  }

  /// Scaffolds a BLoC project with feature-based architecture for a given
  /// [project], logging progress through [logger].
  Future<void> _scaffoldBlocFeatureProject(
    Project project,
    Logger logger,
  ) async {
    logger.progress(
      'Scaffolding BLoC project with feature-based architecture...',
    );

    const featureName = 'counter';
    final featurePath = '${project.name}/lib/presentation/$featureName';

    // Create Feature Directory
    await _flutterCli.createDirectory(featurePath);

    // Presentation Layer
    await _flutterCli.createDirectory('$featurePath/cubit');
    await _flutterCli.createDirectory('$featurePath/views');
    await _flutterCli.createDirectory('$featurePath/widgets');

    await _flutterCli.createFile(
      '$featurePath/cubit/${featureName}_cubit.dart',
      content: _counterCubitContent,
    );

    await _flutterCli.createFile(
      '$featurePath/cubit/counter_state.dart',
      content: _counterStateContent,
    );

    await _flutterCli.createFile(
      '$featurePath/views/${featureName}_page.dart',
      content: _counterPageContent(
        pathToCubit: '../cubit/${featureName}_cubit.dart',
        pathToWidget: '../widgets/${featureName}_text.dart',
      ),
    );

    await _flutterCli.createFile(
      '$featurePath/widgets/${featureName}_text.dart',
      content: _counterTextWidgetContent(
        pathToCubit: '../cubit/${featureName}_cubit.dart',
      ),
    );

    logger
      ..progress(
        // ignore: lines_longer_than_80_chars
        'Feature-based BLoC structure for $featureName app generated successfully.',
      )
      ..progress(
        'Updating main.dart with $featureName page...',
      );
    await _scaffoldMainDotDart(
      basePath: '${project.name}/lib',
      counterPagePath:
          'presentation/$featureName/views/${featureName}_page.dart',
    );
    logger.progress('main.dart updated successfully.');
  }

  /// Scaffolds a BLoC project with clean architecture for a given [project],
  /// logging progress through [logger].
  Future<void> _scaffoldBlocCleanProject(Project project, Logger logger) async {
    logger.progress('Scaffolding BLoC project with clean architecture...');

    const featureName = 'counter';
    final basePath = '${project.name}/lib';
    final presentationPath = '$basePath/presentation/$featureName';
    final domainPath = '$basePath/domain/$featureName';
    final dataPath = '$basePath/data/$featureName';

    await _flutterCli.createDirectory(presentationPath);
    await _flutterCli.createDirectory(domainPath);
    await _flutterCli.createDirectory(dataPath);

    await _flutterCli.createFile(
      '$domainPath/${featureName}_cubit.dart',
      content: _counterCubitContent,
    );

    await _flutterCli.createFile(
      '$domainPath/${featureName}_state.dart',
      content: _counterStateContent,
    );

    await _flutterCli.createFile(
      '$presentationPath/${featureName}_page.dart',
      content: _counterPageContent(
        pathToCubit: '../../domain/$featureName/${featureName}_cubit.dart',
        pathToWidget: '${featureName}_text.dart',
      ),
    );

    await _flutterCli.createFile(
      '$presentationPath/${featureName}_text.dart',
      content: _counterTextWidgetContent(
        pathToCubit: '../../domain/$featureName/${featureName}_cubit.dart',
      ),
    );

    logger
      ..progress(
        // ignore: lines_longer_than_80_chars
        'Clean architecture BLoC structure for $featureName app generated successfully.',
      )
      ..progress('Updating main.dart with $featureName page...');
    await _scaffoldMainDotDart(
      basePath: basePath,
      counterPagePath: 'presentation/$featureName/${featureName}_page.dart',
    );
    logger.progress('main.dart updated successfully.');
  }

  /// Logs an info message indicating that Riverpod project scaffolding is
  /// not yet supported.
  Future<void> _scaffoldRiverpodProject(Project project, Logger logger) async {
    logger.info('Scaffolding Riverpod project...');
    throw UnimplementedError('Riverpod is not yet supported.');
    // Generate Riverpod files and structure
    // Any other Riverpod specific setup
  }

  /// Logs an info message indicating that Provider project scaffolding is
  /// not yet supported.
  Future<void> _scaffoldProviderProject(Project project, Logger logger) async {
    logger.info('Scaffolding Provider project...');
    throw UnimplementedError('Provider is not yet supported.');
    // Generate Provider files and structure
    // Any other Provider specific setup
  }

  Future<void> _scaffoldMainDotDart({
    required String basePath,
    required String counterPagePath,
  }) async {
    await _flutterCli.createFile(
      '$basePath/main.dart',
      content: '''
import 'package:flutter/material.dart';
import '$counterPagePath';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}
''',
    );
  }

  String get _counterCubitContent => '''
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_cubit.freezed.dart';
part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(count: 0));

  void increment() => emit(state.copyWith(count: state.count + 1));
  void decrement() => emit(state.copyWith(count: state.count - 1));
}
''';

  String get _counterStateContent => r'''
part of 'counter_cubit.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    required int count,
  }) = _CounterState;
}
''';

  String _counterPageContent({
    required String pathToCubit,
    required String pathToWidget,
  }) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '$pathToCubit';
import '$pathToWidget';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hummingbird Counter')),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
''';

  String _counterTextWidgetContent({required String pathToCubit}) => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '$pathToCubit';

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state.count);
    return Text('\$count', style: theme.textTheme.displayLarge);
  }
}
''';
}
