abstract class Failure {
  Failure({required this.errorMessage});

  final String errorMessage;
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.errorMessage});
}
