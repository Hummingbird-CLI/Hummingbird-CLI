import 'package:hummingbird_cli/src/data/cli/flutter_cli.dart';
import 'package:hummingbird_cli/src/domain/models/project.dart';
import 'package:mason_logger/mason_logger.dart';

class ArchitectureRepository {
  /// {@macro project_repository}
  ArchitectureRepository({
    FlutterCli? flutterCli,
  }) : _flutterCli = flutterCli ?? FlutterCli();

  final FlutterCli _flutterCli;

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

  Future<void> _scaffoldBlocProject(Project project, Logger logger) async {
    switch (project.architecture) {
      case Architecture.featureBased:
        await _scaffoldBlocFeatureProject(project, logger);
      case Architecture.clean:
        throw UnimplementedError('Clean architecture is not yet supported.');
    }
  }

  Future<void> _scaffoldBlocFeatureProject(
    Project project,
    Logger logger,
  ) async {
    // ignore: lines_longer_than_80_chars
    // TODO(benlrichards): This is for a feature-based architecture. We need to add support for clean architecture.
    logger.info('Scaffolding BLoC project with feature-based architecture...');

    const featureName = 'counter';
    final featurePath = '${project.name}/lib/presentation/$featureName';

    // Create Feature Directory
    await _flutterCli.createDirectory(featurePath);

    // Presentation Layer
    await _flutterCli.createDirectory('$featurePath/cubit');
    await _flutterCli.createDirectory('$featurePath/views');
    await _flutterCli.createDirectory('$featurePath/widgets');

    await _flutterCli.createFile(
      '$featurePath/cubit/${featureName}_bloc.dart',
      content: '''
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_cubit.freezed.dart';
part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(count: 0));

  void increment() => emit(state.copyWith(count: state.count + 1));
  void decrement() => emit(state.copyWith(count: state.count - 1));
}

''',
    );

    await _flutterCli.createFile(
      '$featurePath/cubit/counter_state.dart',
      content: r'''
part of 'counter_cubit.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    required int count,
  }) = _CounterState;
}
''',
    );

    await _flutterCli.createFile(
      '$featurePath/views/${featureName}_page.dart',
      content: '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/presentation/counter/counter.dart';
import 'package:test_project/presentation/counter/widgets/counter_text.dart';

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
      appBar: AppBar(title: const Text('Counter')),
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
''',
    );

    await _flutterCli.createFile(
      '$featurePath/widgets/${featureName}_text.dart',
      content: r'''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/presentation/counter/cubit/counter_cubit.dart';

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
''',
    );

    logger.info(
      'Feature-based BLoC structure for $featureName app generated successfully.',
    );
  }

  Future<void> _scaffoldProviderProject(Project project, Logger logger) async {
    logger.info('Scaffolding Provider project...');

    // Generate Provider files and structure
    // Any other Provider specific setup
  }

  Future<void> _scaffoldRiverpodProject(Project project, Logger logger) async {
    logger.info('Scaffolding Riverpod project...');
    // Generate Riverpod files and structure
    // Any other Riverpod specific setup
  }
}
