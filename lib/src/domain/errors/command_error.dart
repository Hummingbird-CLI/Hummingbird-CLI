class CommandError implements Exception {
  CommandError(this.message);
  final String message;

  @override
  String toString() => message;
}
