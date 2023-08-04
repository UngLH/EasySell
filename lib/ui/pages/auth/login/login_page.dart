import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/auth/login/login_cubit.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordSecured = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription _showMessageSubscription;
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _showLoadingSubscription;
  LoginCubit? _cubit;

  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  @override
  void initState() {
    _cubit = BlocProvider.of<LoginCubit>(context);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });

    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
    _navigationSubscription =
        _cubit!.navigatorController.stream.listen((event) {
      if (event == LoginNavigator.OPEN_CREATE_SHOP) {
        Application.router?.navigateTo(context, Routers.createShop);
      } else {
        Application.router?.navigateTo(context, Routers.home);
      }
    });
    super.initState();
  }

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  @override
  void dispose() {
    _cubit!.close();
    _showMessageSubscription.cancel();
    _navigationSubscription.cancel();
    _showLoadingSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.mainColor, size: 40)),
            overlayColor: Colors.black,
            overlayOpacity: 0.8,
            child: BlocBuilder<LoginCubit, LoginState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state.loginStatus == LoadStatus.LOADING) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ));
                  } else {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 100, 15, 25),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(AppImages.icLogin),
                              const Text(
                                "Xin chào!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Chào mừng bạn đến với ứng dụng Easy Sell. Hãy điền thông tin để đăng nhập",
                                style: TextStyle(
                                    color: AppColors.textColor, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 70,
                                child: Center(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng nhập email";
                                      else if (!Validator.validateEmail(
                                          value)) {
                                        return "Email không đúng định dạng";
                                      } else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: const Icon(Icons.email),
                                      hintStyle: const TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.mainColor),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    maxLines: 1,
                                    textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 70,
                                child: Center(
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: isPasswordSecured,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng nhập mật khẩu";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isPasswordSecured =
                                                  !isPasswordSecured;
                                            });
                                          },
                                          splashColor: Colors.white,
                                          child: Icon(isPasswordSecured
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined)),
                                      hintText: "Mật khẩu",
                                      hintStyle: const TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.mainColor),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      "Quên mật khẩu?",
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.mainColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _cubit?.signIn(
                                                _emailController.text,
                                                _passwordController.text);
                                          }
                                          // _cubit!.checkUserSignIn();
                                        },
                                        child: const Text(
                                          "Đăng nhập",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        )),
                                  )),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Bạn chưa có tài khoản?"),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Application.router?.navigateTo(
                                                  context, Routers.signUp);
                                            },
                                            child: const Text(
                                              "Đăng ký",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.yellowMainColor,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ));
                  }
                })));
  }
}
