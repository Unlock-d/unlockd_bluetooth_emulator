import 'package:fpdart/fpdart.dart';

Exception _logException(Exception o) {
  print('object: ${o.runtimeType} - $o');
  return o;
}

Either<L, R> logException<L extends Exception, R>(Either<L, R> either) =>
    either.match<Either<L, R>>(
      (l) => Either.left(l)..mapLeft(_logException),
      Either.right,
    );
