import 'package:clean_architecture/features/core/utils/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
  // assert
  expect(bloc.initialState, equals(Empty()));
  });

  group('get trivia for concrete number', () {
    final tNumberString = "1";
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(number: 1, text: "Test text");

    test('should call the input converter and convert the string to uint',
      ()async {
        // arrange
        when(mockInputConverter.stringsToUInt(any))
          .thenReturn(Right(tNumberParsed));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(mockInputConverter.stringsToUInt(any));
        // assert
        verify(mockInputConverter.stringsToUInt(tNumberString));
      },
    );

    test('should emit [Error] when input is invalid',
      ()async {
        // arrange
        when(mockInputConverter.stringsToUInt(any))
          .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );

    test('should get data from the concrete use case',
      ()async {
        // arrange
        when(mockInputConverter.stringsToUInt(tNumberString))
          .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(params: anyNamed("params")))
          .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(params: anyNamed("params")));
        // assert
        verify(mockGetConcreteNumberTrivia(params: anyNamed("params")));
      },
    );

  });

}