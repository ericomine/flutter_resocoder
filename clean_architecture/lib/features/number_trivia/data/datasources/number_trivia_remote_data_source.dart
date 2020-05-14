import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

// Notice that even though we'll have to use external URL for API,
// which would be a string,the remote data source has no reference it.
// This decoupling allows eg replacing http package for chopper.

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}