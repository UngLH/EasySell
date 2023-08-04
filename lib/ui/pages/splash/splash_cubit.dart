import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/storage/share_preferences_helper.dart';

import 'package:rxdart/rxdart.dart';

part 'splash_state.dart';

enum SplashNavigator { OPEN_HOME, OPEN_LOGIN, OPEN_CREATE_SHOP }

class SplashCubit extends Cubit<SplashState> {
  final messageController = PublishSubject<String>();
  final navigatorController = PublishSubject<SplashNavigator>();

  SplashCubit() : super(SplashState());

  void checkUserSignIn() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          navigatorController.sink.add(SplashNavigator.OPEN_LOGIN);
        } else {
          String? userId = await SharedPreferencesHelper.getUserId();
          getShop(userId.toString());
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getShop(String userId) async {
    FirebaseFirestore.instance
        .collection('shop')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        navigatorController.sink.add(SplashNavigator.OPEN_CREATE_SHOP);
      } else {
        SharedPreferencesHelper.setShopId(querySnapshot.docs[0].id);
        navigatorController.sink.add(SplashNavigator.OPEN_HOME);
      }
    });
  }

  @override
  Future<void> close() {
    messageController.close();
    navigatorController.close();
    return super.close();
  }
}
