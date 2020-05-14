import 'package:clean_architecture/features/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call({@required Params params});
}