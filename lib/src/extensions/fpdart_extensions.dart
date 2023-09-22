import 'package:fpdart/fpdart.dart';

// TODO(PJ): create proper bind methods for every type
// A bind method should receive a function which takes a type of
// generic value A and return a type with generic value B
// e.g. TaskEither<M, S> bind<M, S>(TaskEither<M, S> Function(TaskEither<L, R>) f)

extension TaskEitherX<L, R> on TaskEither<L, R> {
  TaskOption<R> toTaskOption() =>
      TaskOption(() async => (await run()).toOption());

  TaskEither<L, R> bind(Either<L, R> Function(Either<L, R>) f) =>
      TaskEither(() async => f(await run()));

  TaskEither<L, C> chainTask<C>(
    TaskEither<L, C> Function(R) chain,
  ) =>
      flatMap((r) => chain(r).orElse(TaskEither.left));
}

extension TaskOptionX<R> on TaskOption<R> {
  TaskOption<R> chain(TaskOption<R> Function(R) f) => TaskOption(
        () async => run().then(
          (option) => option.match(
            Option.none,
            (t) async => f(t).run(),
          ),
        ),
      );

  TaskOption<C> chainTask<C>(
    TaskOption<C> Function(R) chain,
  ) =>
      flatMap((b) => chain(b).map((c) => c).orElse<C>(TaskOption.none));

  TaskOption<R> filter(bool Function(R t) f) =>
      TaskOption(() async => (await run()).filter(f));
}

extension OptionX<R> on Option<R> {
  TaskEither<L, R> toTaskEither<L>(
    TaskEither<L, R> Function(Option<R>) f,
    L Function() left,
  ) =>
      TaskEither(
        () async => match(
          () => f(this).run(),
          (r) => f(this).run(),
        ),
      );
}
