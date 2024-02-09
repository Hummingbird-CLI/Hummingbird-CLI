/// Project model used to create a new Flutter project.
class Project {
  /// Creates a [Project].
  Project({
    required this.name,
    required this.org,
    required this.stateManagement,
  });

  /// The name of the project.
  final String name;

  /// The organization of the project.
  final String org;

  /// The state management solution for the project.
  final String stateManagement;
}
