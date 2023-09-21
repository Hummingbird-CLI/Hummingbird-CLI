/// Error class for command errors
class CommandError implements Exception {
  /// Creates a command error with [message].
  CommandError(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => message;
}
