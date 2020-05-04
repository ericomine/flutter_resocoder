abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async;
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async;
}