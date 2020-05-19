part of 'number_trivia_bloc_bloc.dart';

abstract class NumberTriviaBlocState extends Equatable {
  const NumberTriviaBlocState();
}

class NumberTriviaBlocInitial extends NumberTriviaBlocState {
  @override
  List<Object> get props => [];
}
