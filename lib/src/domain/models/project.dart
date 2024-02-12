/// Project model used to create a new Flutter project.
class Project {
  /// Creates a [Project].
  Project({
    required this.name,
    required this.org,
    required this.stateManagement,
    required this.useHydratedBloc,
    required this.useReplayBloc,
  });

  /// The name of the project.
  final String name;

  /// The organization of the project.
  final String org;

  /// The state management solution for the project.
  final StateManagement stateManagement;

  /// Whether to use hydrated_bloc.
  final bool? useHydratedBloc;

  /// Whether to use replay_bloc.
  final bool? useReplayBloc;
}

enum StateManagement { bloc, provider, riverpod }
