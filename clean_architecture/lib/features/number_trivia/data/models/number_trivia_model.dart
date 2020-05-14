import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {

  NumberTriviaModel({
    @required int number,
    @required String text
    }) : super(number: number, text: text);
}