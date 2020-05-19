import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/number_trivia.dart';
import '../../../core/utils/input_converter.dart';


part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia _concrete;
  final GetRandomNumberTrivia _random;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    @required concrete,
    @required random,
    @required this.inputConverter
  }) : assert(concrete != null),
    assert(random != null),
    _concrete = concrete,
    _random = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = 
        inputConverter.stringsToUInt(event.numberString);
    
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia = await _concrete(params: Params(number: integer));
          yield failureOrTrivia.fold(
            (failure) => throw UnimplementedError(),
            (trivia) => Loaded(trivia: trivia)
          );
        }
      );
    }

    
  }
}
