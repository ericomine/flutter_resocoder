import 'package:clean_architecture/features/core/errors/exception.dart';
import 'package:clean_architecture/features/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
  implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock
  implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock
  implements NetworkInfo {}

void main() {

  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource : mockRemoteDataSource,
      localDataSource : mockLocalDataSource,
      networkInfo : mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    // Data for mocks and assertions:
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: "Test text.",
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    
    test(
      'should check if device is online',
      ()async {
        // arrange
        when(mockNetworkInfo.isConnected)
        .thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    ); 

    group('device online', () {
    
      setUp(() {
        when(mockNetworkInfo.isConnected)
        .thenAnswer((_) async => true);
      });

      test(
        'should return remote data when device online',
        ()async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
        // This is not actually testing the output or the result of the
        // repository.getConcreteNumberTrivia() method, instead,
        // what it's really looking at is what data source has been accessed,
        // ie it verifies whether getConcreteNumberTrivia() has been called
        // on mockRemoteDataSource, not mockLocalDataSource. That is why,
        // it doesn't matter what's returned by mockRemoteDataSource, what
        // matter is that it has been called.
      );
    });

    test(
      'should cache the data locally after call to remote data source',
      ()async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
      },
    );

    test(
      'should return ServerFailure when call to remote data source is unsuccessfull',
      ()async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
        .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      },
    );

  });
}