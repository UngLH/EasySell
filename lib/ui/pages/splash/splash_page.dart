import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/splash/splash_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  late SplashCubit _cubit;
  late StreamSubscription _navigationSubscription;

  @override
  void initState() {
    _cubit = SplashCubit();
    _cubit.checkUserSignIn();
    super.initState();
    _navigationSubscription = _cubit.navigatorController.stream.listen((event) {
      Future.delayed(const Duration(seconds: 2), () {
        switch (event) {
          case SplashNavigator.OPEN_HOME:
            showHome();
            break;
          case SplashNavigator.OPEN_LOGIN:
            showLogin();
            break;
          case SplashNavigator.OPEN_CREATE_SHOP:
            showCreateShop();
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _cubit.close();
    _navigationSubscription.cancel();
    super.dispose();
  }

  void showLogin() {
    Application.router?.navigateTo(context, Routers.login, replace: true);
  }

  void showHome() {
    Application.router?.navigateTo(context, Routers.home, replace: true);
  }

  void showCreateShop() {
    Application.router?.navigateTo(context, Routers.createShop, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.icApp,
                      width: 150, height: 150, fit: BoxFit.fill),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Easy Sell",
                      style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainColor)),
                  LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.mainColor, size: 40)
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 30),
          ),
        ],
      ),
    );
  }
}
