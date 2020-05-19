part of 'number_trivia_bloc_bloc.dart';

abstract class NumberTriviaBlocEvent extends Equatable {
  NumberTriviaBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaBlocEvent {
  // String comes from UI.
  // Convertion to int should not be handled in presentation layer.
  final String numberString;

  GetTriviaForConcreteNumber({
    @required this.numberString
    }) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaBlocEvent {}