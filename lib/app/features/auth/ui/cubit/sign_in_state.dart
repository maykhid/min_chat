part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  const SignInState.unknown() : this._();

  const SignInState.processing()
      : this._(status: DataResponseStatus.processing);

  const SignInState.done()
      : this._(
          status: DataResponseStatus.success,
        );

  const SignInState.failed({String? message})
      : this._(message: message, status: DataResponseStatus.error);

  const SignInState._({
    this.message,
    this.status = DataResponseStatus.initial,
  });

  final DataResponseStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
