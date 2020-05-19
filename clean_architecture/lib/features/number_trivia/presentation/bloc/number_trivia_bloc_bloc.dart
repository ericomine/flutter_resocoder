import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_bloc_event.dart';
part 'number_trivia_bloc_state.dart';

class NumberTriviaBlocBloc extends Bloc<NumberTriviaBlocEvent, NumberTriviaBlocState> {
  @override
  NumberTriviaBlocState get initialState => NumberTriviaBlocInitial();

  @override
  Stream<NumberTriviaBlocState> mapEventToState(
    NumberTriviaBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
