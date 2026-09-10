
abstract class BaseBlocState {}

class InitialState extends BaseBlocState {}

class LoadingState extends BaseBlocState {}

class SuccessState extends BaseBlocState {}

class EmptyState extends BaseBlocState {}

class ErrorState extends BaseBlocState {
  String? errorMessage;
  ErrorState({this.errorMessage});
}
