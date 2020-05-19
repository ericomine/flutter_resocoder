import 'package:clean_architecture/features/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
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

    test('should return a failure when string is not uint',
      ()async {
        // arrange
        final str = "abc";
        // act
        final result = converter.stringsToUInt(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test('should return a failure when string is negative integer',
      ()async {
        // arrange
        final str = "-123";
        // act
        final result = converter.stringsToUInt(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });

}