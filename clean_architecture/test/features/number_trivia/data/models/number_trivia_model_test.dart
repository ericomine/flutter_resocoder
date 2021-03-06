import 'dart:convert';

import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text.");

  test('should be a subclass of NumberTrivia entity',
    ()async {
      // arrange
      
      // act
      
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('from json', () {

    test(
      'should return valid model when JSON number is integer',
      ()async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

     test(
      'should return valid model when JSON number is double',
      ()async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

  });

  group('to json', () {
    test(
      'should ',
      ()async {
        // arrange
        final expectedMap = {
          "text" : "Test text.",
          "number" : 1,
        };
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        expect(result, expectedMap);
      },
    );
  });
}