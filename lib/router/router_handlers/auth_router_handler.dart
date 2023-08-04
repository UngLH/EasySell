import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/repositories/bank_repository.dart';
import 'package:mobile/ui/pages/auth/login/login_cubit.dart';
import 'package:mobile/ui/pages/auth/login/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/auth/signUp/sign_up_cubit.dart';
import 'package:mobile/ui/pages/auth/signUp/sign_up_page.dart';
import 'package:mobile/ui/pages/shopCreate/shop_create_cubit.dart';
import 'package:mobile/ui/pages/shopCreate/shop_create_page.dart';
import 'package:mobile/ui/pages/splash/splash_page.dart';

Handler splashHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
      SplashPage(),
);
Handler loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return LoginCubit();
    },
    child: const LoginPage(),
  );
});
Handler createShopHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      final bankRepository = RepositoryProvider.of<BankRepository>(context);
      return ShopCreateCubit(bankRepository: bankRepository);
    },
    child: const ShopCreatePage(),
  );
});
Handler signUpHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return SignUpCubit();
    },
    child: const SignUpPage(),
  );
});
