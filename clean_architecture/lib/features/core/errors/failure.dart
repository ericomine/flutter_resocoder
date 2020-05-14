import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

class ServerFailure implements Failure {
  @override
  // TODO: implement props
  List get props => null;
}

class CacheFailure implements Failure {
  @override
  // TODO: implement props
  List get props => null;
}