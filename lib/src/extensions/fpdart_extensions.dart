import 'package:fpdart/fpdart.dart';

extension TaskEitherX<L, R> on TaskEither<L, R> {
  TaskOption<R> toTaskOption() =>
      TaskOption(() async => (await run()).toOption());

  TaskEither<L, R> bind(Either<L, R> Function(Either<L, R>) task) =>
      TaskEither(() async => task(await run()));
}
