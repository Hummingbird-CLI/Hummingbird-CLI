import 'package:hummingbird_cli/src/domain/models/state_management.dart';

/// An implementation of the [StateManagement] interface
/// for the `Provider` state management solution.
///
/// This class provides the necessary configurations,
/// representations, and methods specific to the `Provider`
/// state management system in Flutter. It covers aspects
/// from initialization to potential additional configurations.
///
/// Example usage:
///
/// ```dart
/// final stateManagement = ProviderStateManagement();
/// print(stateManagement.initializationCode);
/// ```
class ProviderStateManagement implements StateManagement {
  /// Returns the initialization code using
  /// `ChangeNotifierProvider` for the `Provider` system.
  @override
  String get initializationCode => 'ChangeNotifierProvider<MyModel>(...)';

  /// Returns the dependency injection code using
  /// `Provider` for services or other dependencies.
  @override
  String get dependencyInjectionCode => 'Provider<MyService>(...)';

  /// Represents the state using a
  /// `ChangeNotifier` class for the `Provider` system.
  @override
  String get stateRepresentation =>
      'class MyModel extends ChangeNotifier { ... }';

  /// Returns the methods or functions to manipulate the state using
  /// `notifyListeners` for the `Provider` system.
  @override
  String get stateManipulationCode =>
      'void updateData() { ... notifyListeners(); }';

  /// Returns the code to access the state from the UI using
  /// `context.read` for the `Provider` system.
  @override
  String get stateAccessCode => 'context.read<MyModel>()';

  /// Returns an empty string as the `Provider` system
  /// doesn't require explicit cleanup in most cases.
  @override
  String get cleanupCode => '';

  /// Returns any additional configurations or utilities
  /// specific to the `Provider` state management solution.
  @override
  String get additionalConfigurations => 'Any other specific configurations';
}
