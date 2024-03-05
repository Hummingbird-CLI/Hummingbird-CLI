/// A collection of String extension methods.
extension StringExtensions on String {
  /// Capitalizes the first letter of each word in the string
  /// for snake_case and camelCase.
  String capitalize() {
    // Handle snake_case by splitting into words, capitalizing them,
    // and joining without underscores.
    if (contains('_')) {
      return split('_').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join();
    }
    // Handle camelCase by simply capitalizing the first letter
    // without altering the rest.
    else {
      if (isEmpty) return this;
      return this[0].toUpperCase() + substring(1);
    }
  }
}
