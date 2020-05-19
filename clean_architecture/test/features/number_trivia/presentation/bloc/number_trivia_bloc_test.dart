import 'package:clean_architecture/features/core/errors/failure.dart';
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

    void setupMockInputConverterSuccess() =>
        when(mockInputConverter.stringsToUInt(any))
            .thenReturn(Right(tNumberParsed));

    void setupMockGetConcreteNumberTriviaSuccess() =>
        when(mockGetConcreteNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Right(tNumberTrivia));

    void setupMockGetConcreteNumberTriviaInputFailure() =>
        when(mockInputConverter.stringsToUInt(any))
            .thenReturn(Left(InvalidInputFailure()));

    void setupMockGetConcreteNumberTriviaServerFailure() =>
        when(mockGetConcreteNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Left(ServerFailure()));

    void setupMockGetConcreteNumberTriviaCacheFailure() =>
        when(mockGetConcreteNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Left(CacheFailure()));

    test(
      'should call the input converter and convert the string to uint',
      () async {
        // arrange
        setupMockInputConverterSuccess();
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(mockInputConverter.stringsToUInt(any));
        // assert
        verify(mockInputConverter.stringsToUInt(tNumberString));
      },
    );

    test(
      'should emit [Error] when input is invalid',
      () async {
        // arrange
        setupMockGetConcreteNumberTriviaInputFailure();
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

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setupMockInputConverterSuccess();
        setupMockGetConcreteNumberTriviaSuccess();
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(
            mockGetConcreteNumberTrivia(params: anyNamed("params")));
        // assert
        verify(mockGetConcreteNumberTrivia(params: anyNamed("params")));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is retrieved succesfully',
      () async {
        // arrange
        setupMockInputConverterSuccess();
        setupMockGetConcreteNumberTriviaSuccess();
        // assert later
        final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        setupMockInputConverterSuccess();
        setupMockGetConcreteNumberTriviaServerFailure();
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setupMockInputConverterSuccess();
        setupMockGetConcreteNumberTriviaCacheFailure();
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(params: anyNamed("params")));
        // assert
        verify(mockGetRandomNumberTrivia(params: anyNamed("params")));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(params: anyNamed("params")))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
