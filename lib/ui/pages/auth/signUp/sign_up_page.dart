import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/auth/signUp/sign_up_cubit.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/utils/validators.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSecuredPassword = true;
  bool isSecuredConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showMessageSubscription;
  late StreamSubscription _navigationSubscription;
  late StreamSubscription _showLoadingSubscription;
  SignUpCubit? _cubit;

  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');

  @override
  void initState() {
    _cubit = BlocProvider.of<SignUpCubit>(context);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });
    _emailController.addListener(() {
      _cubit!.emailChange(_emailController.text);
    });
    _passwordController.addListener(() {
      _cubit!.passwordChange(_passwordController.text);
    });
    _confirmPasswordController.addListener(() {
      _cubit!.confirmPasswordChange(_confirmPasswordController.text);
    });

    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });

    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else if (status == LoadStatus.SUCCESS) {
        Application.router!.navigateTo(context, Routers.login);
        context.loaderOverlay.hide();
      } else {
        context.loaderOverlay.hide();
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
    _showMessageSubscription.cancel();
    _navigationSubscription.cancel();
    _showLoadingSubscription.cancel();
    // TODO: implement dispose
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 100, 15, 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Đăng ký với email!",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Hãy điền thông tin để để đăng ký tài khoản",
                  style: TextStyle(color: AppColors.textColor, fontSize: 14),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 70,
                  child: Center(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (Validator.validateNullOrEmpty(value!)) {
                          return "Vui lòng nhập vào email";
                        } else if (!Validator.validateEmail(value)) {
                          return "Email không đúng định dạng";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        hintStyle: const TextStyle(
                            color: AppColors.textColor, fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _passwordField(
                    "Mật khẩu", _passwordController, isSecuredPassword),
                const SizedBox(
                  height: 20,
                ),
                _passwordField("Nhập lại mật khẩu", _confirmPasswordController,
                    isSecuredConfirmPassword),
                const SizedBox(
                  height: 20,
                ),
                _signUpButton(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          color: AppColors.lineColor,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Hoặc"),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.lineColor,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: const BorderSide(
                                    color: AppColors.lineColor)),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.icGoogle,
                                  width: 25, height: 25),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Đăng nhập với Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )),
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Bạn đã có tài khoản?"),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: () {
                                Application.router!
                                    .navigateTo(context, Routers.login);
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w600),
                              )),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      bloc: _cubit,
      buildWhen: (prev, current) {
        return (prev.signUpStatus != current.signUpStatus) ||
            (prev.email != current.email) ||
            (prev.password != current.password) ||
            (prev.confirmPassword != current.confirmPassword);
      },
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _cubit?.signUp(state.email, state.password);
                    }
                  },
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
            )),
          ],
        );
      },
    );
  }

  Widget _passwordField(String hintText,
      TextEditingController textEditingController, bool obscure) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        bloc: _cubit,
        buildWhen: (prev, current) {
          return (prev.signUpStatus != current.signUpStatus) ||
              (prev.email != current.email) ||
              (prev.password != current.password) ||
              (prev.confirmPassword != current.confirmPassword);
        },
        builder: (context, state) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 70,
                child: Center(
                  child: TextFormField(
                    controller: textEditingController,
                    obscureText: obscure,
                    validator: (value) {
                      if (Validator.validateNullOrEmpty(value!)) {
                        return "Vui lòng nhập mật khẩu";
                      } else if (!state.isMatchPassword) {
                        return "Mật khẩu chưa khớp";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          splashColor: Colors.white,
                          child: Icon(obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined)),
                      hintText: hintText,
                      hintStyle: const TextStyle(
                          color: AppColors.textColor, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
