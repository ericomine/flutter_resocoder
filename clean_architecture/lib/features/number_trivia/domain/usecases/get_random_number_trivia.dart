import 'package:clean_architecture/features/core/errors/failure.dart';
import 'package:clean_architecture/features/core/usecases/usecase.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia({@required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call({@required NoParams params}) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {}