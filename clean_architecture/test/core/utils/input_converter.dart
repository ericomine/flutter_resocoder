import 'package:clean_architecture/features/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('string to UInt', () {
    test('should return integer when string represents uint',
      ()async {
        // arrange
        final str = "123";
        // act
        final result = converter.stringsToUInt(str);
        // assert
        expect(result, Right(123));
      },
    );
  });

}