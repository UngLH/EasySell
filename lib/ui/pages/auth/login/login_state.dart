part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoadStatus? loginStatus;
  final String? email;
  final String? password;

  const LoginState({this.loginStatus, this.email, this.password});

  bool get isValid {
    if (isValidEmail) {
      return true;
    } else {
      return false;
    }
  }

  bool get isValidEmail {
    return Validator.validateEmail(email);
  }

  LoginState copyWith({
    LoadStatus? loginStatus,
    String? email,
    String? password,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [
        loginStatus,
        email,
        password,
      ];
}
