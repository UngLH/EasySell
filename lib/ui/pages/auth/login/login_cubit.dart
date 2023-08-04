import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/models/entities/shop/shop_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'login_state.dart';

enum LoginNavigator { OPEN_HOME, OPEN_CREATE_SHOP }

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final navigatorController = PublishSubject<LoginNavigator>();
  final showLoading = PublishSubject<LoadStatus>();

  void signIn(String email, String password) async {
    try {
      showLoading.sink.add(LoadStatus.LOADING);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferencesHelper.setUserId(credential.user?.uid ?? "");
      SharedPreferencesHelper.setEmail(credential.user?.email ?? "");
      showLoading.sink.add(LoadStatus.SUCCESS);
      emit(state.copyWith(loginStatus: LoadStatus.SUCCESS));
      String? userId = await SharedPreferencesHelper.getUserId();
      await getShop(userId.toString());
    } on FirebaseAuthException catch (e) {
      showLoading.sink.add(LoadStatus.FAILURE);
      emit(state.copyWith(loginStatus: LoadStatus.FAILURE));
      if (e.code == 'user-not-found') {
        showMessageController.sink.add(SnackBarMessage(
          message: "Không tìm thấy tài khoản của bạn",
          type: SnackBarType.ERROR,
        ));
      } else if (e.code == 'wrong-password') {
        showMessageController.sink.add(SnackBarMessage(
          message: "Tài khoản mật khẩu không chính xác",
          type: SnackBarType.ERROR,
        ));
      }
    }
  }

  // void getShopData() {
  //   CollectionReference shop = FirebaseFirestore.instance.collection('shop');
  //   shop.
  //   }

  Future<void> getShop(String userId) async {
    FirebaseFirestore.instance
        .collection('shop')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        showLoading.sink.add(LoadStatus.SUCCESS);
        navigatorController.sink.add(LoginNavigator.OPEN_CREATE_SHOP);
      } else {
        SharedPreferencesHelper.setShopId(querySnapshot.docs[0].id);
        navigatorController.sink.add(LoginNavigator.OPEN_HOME);
      }
    });
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
