sealed class Result<T, E> {
  const Result();
  R match<R>({required R Function(T ok) ok, required R Function(E err) err});
}

class Ok<T, E> extends Result<T, E> {
  final T value;
  const Ok(this.value);
  @override
  R match<R>({required R Function(T ok) ok, required R Function(E err) err}) =>
      ok(value);
}

class Err<T, E> extends Result<T, E> {
  final E error;
  const Err(this.error);
  @override
  R match<R>({required R Function(T ok) ok, required R Function(E err) err}) =>
      err(error);
}
