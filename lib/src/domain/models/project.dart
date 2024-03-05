/// Project model used to create a new Flutter project.
class Project {
  /// Creates a [Project].
  Project({
    required this.name,
    required this.org,
    required this.stateManagement,
    required this.useHydratedBloc,
    required this.useReplayBloc,
    required this.architecture,
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

  /// The architecture of the project.
  final Architecture architecture;
}

/// Defines the state management solutions available for a project.
///
enum StateManagement {
  /// BLoC
  bloc,

  /// Provider
  provider,

  /// Riverpod

  riverpod
}

/// Represents the architectural patterns supported for a project.
///
enum Architecture {
  /// Clean
  clean,

  /// Feature-Based
  featureBased
}
