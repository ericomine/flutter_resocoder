import 'package:clean_architecture/features/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringsToUInt(String str) {
    // TODO: Implement
    return null;
  }
}

class InvalidInputFailure extends Failure {}