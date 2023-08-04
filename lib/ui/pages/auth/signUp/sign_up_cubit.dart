import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }

  void signUp(String email, String password) async {
    //validate
    if (email.isEmpty) {
      showMessageController.sink.add(SnackBarMessage(
        message: 'Chưa nhập số điện thoại ',
        type: SnackBarType.ERROR,
      ));
      return;
    }
    if (password.isEmpty) {
      showMessageController.sink.add(SnackBarMessage(
        message: 'Chưa nhập mật khẩu',
        type: SnackBarType.ERROR,
      ));
      return;
    }
    showLoading.sink.add(LoadStatus.LOADING);
    emit(state.copyWith(signUpStatus: LoadStatus.LOADING));
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showLoading.sink.add(LoadStatus.SUCCESS);
      emit(state.copyWith(signUpStatus: LoadStatus.SUCCESS));
      showMessageController.sink.add(SnackBarMessage(
        message: 'Đăng ký thành công',
        type: SnackBarType.SUCCESS,
      ));
    } on FirebaseAuthException catch (e) {
      showLoading.sink.add(LoadStatus.FAILURE);
      emit(state.copyWith(signUpStatus: LoadStatus.FAILURE));
      if (e.code == 'weak-password') {
        showMessageController.sink.add(SnackBarMessage(
          message: 'Mật khẩu quá yếu',
          type: SnackBarType.ERROR,
        ));
      } else if (e.code == 'email-already-in-use') {
        showMessageController.sink.add(SnackBarMessage(
          message: 'Email đã được sử dụng',
          type: SnackBarType.ERROR,
        ));
      }
    } catch (e) {
      emit(state.copyWith(signUpStatus: LoadStatus.FAILURE));
      print(e);
    }
  }

  void emailChange(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChange(String password) {
    emit(state.copyWith(password: password));
  }

  void confirmPasswordChange(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }
}
