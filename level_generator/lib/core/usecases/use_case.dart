import '../error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCaseWithParams<Type, Params> {
  Future<Either<Failure, Type>?>? call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  Future<Either<Failure, Type>?>? call();
}
