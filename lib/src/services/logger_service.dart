import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/src/domain/file_reader_domain.dart';

Either<L, R> logException<L extends FileHandlingException, R>(
  Either<L, R> either,
) =>
    either.match<Either<L, R>>(
      (l) => Either.left(l)..mapLeft(_logException),
      Either.right,
    );

FileHandlingException _logException(FileHandlingException o) {
  debugPrintStack(stackTrace: o.stackTrace, label: o.cause.toString());
  return o;
}
