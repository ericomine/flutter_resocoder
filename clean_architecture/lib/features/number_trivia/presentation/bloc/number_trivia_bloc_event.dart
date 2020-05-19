part of 'number_trivia_bloc_bloc.dart';

abstract class NumberTriviaBlocEvent extends Equatable {
  NumberTriviaBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaBlocEvent {
  final String numberString;

  GetTriviaForConcreteNumber({
    @required this.numberString
    }) : super([numberString]);
}

class GetTriviaForRandomNumber extends NumberTriviaBlocEvent {}