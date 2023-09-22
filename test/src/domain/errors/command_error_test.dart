import 'package:hummingbird_cli/src/domain/errors/command_error.dart';
import 'package:test/test.dart';

void main() {
  group('CommandError', () {
    test('can be instantiated', () {
      final error = CommandError('message');
      expect(error, isNotNull);
      expect(error.message, 'message');
    });

    test('toString returns message', () {
      final error = CommandError('message');
      expect(error.toString(), 'message');
    });
  });
}
