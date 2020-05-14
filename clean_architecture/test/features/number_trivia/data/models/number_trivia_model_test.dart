import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tNumberTriviaModel = NumberTrivia(number: 1, text: "Test");

  test(
    'should be a subclass of NumberTrivia entity',
    ()async {
      // arrange
      
      // act
      
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

}