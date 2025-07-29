abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.errorMessage});
}
