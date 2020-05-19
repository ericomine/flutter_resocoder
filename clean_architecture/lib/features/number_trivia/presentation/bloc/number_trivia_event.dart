part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  // String comes from UI.
  // Convertion to int should not be handled in presentation layer.
  final String numberString;

  GetTriviaForConcreteNumber({
    @required this.numberString
    }) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}