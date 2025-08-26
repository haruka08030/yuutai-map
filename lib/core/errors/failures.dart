sealed class Failure {
  const Failure();
}

class NetworkFailure extends Failure {}

class AuthRequiredFailure extends Failure {}

class UnknownFailure extends Failure {}
