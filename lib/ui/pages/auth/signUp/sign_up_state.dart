part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final LoadStatus? signUpStatus;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpState(
      {this.signUpStatus = LoadStatus.INITIAL,
      this.email = "",
      this.password = "",
      this.confirmPassword = ""});

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

  bool get isMatchPassword {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  SignUpState copyWith(
      {LoadStatus? signUpStatus,
      String? email,
      String? password,
      String? confirmPassword}) {
    return SignUpState(
        signUpStatus: signUpStatus ?? this.signUpStatus,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword);
  }

  @override
  List<Object?> get props => [signUpStatus, email, password, confirmPassword];
}
