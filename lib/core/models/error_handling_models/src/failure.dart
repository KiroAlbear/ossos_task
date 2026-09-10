abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure(super.message);
}

class CustomFailure extends Failure {
  const CustomFailure(super.message);
}

class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);
}
