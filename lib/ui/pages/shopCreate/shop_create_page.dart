import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/dtos/bank/account_number_check.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/shopCreate/shop_create_cubit.dart';
import 'package:mobile/ui/widgets/app_auto_complete.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/utils/validators.dart';

class ShopCreatePage extends StatefulWidget {
  const ShopCreatePage({super.key});

  @override
  State<ShopCreatePage> createState() => _ShopCreatePageState();
}

class _ShopCreatePageState extends State<ShopCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showLoadingSubscription;
  late StreamSubscription _showMessageSubscription;
  final _shopNameController = TextEditingController(text: '');
  final _shopAddressController = TextEditingController(text: '');
  final _bankNameController = TextEditingController(text: '');
  final _accountNumberController = TextEditingController(text: '');
  final _accountNameController = TextEditingController(text: '');
  ShopCreateCubit? _cubit;
  BankEntity? selectedBank;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ShopCreateCubit>(context);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });

    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else if (status == LoadStatus.LOAD_SUCCESS_AND_NAVIGATE) {
        context.loaderOverlay.hide();
        Application.router?.navigateTo(context, Routers.home);
      } else {
        context.loaderOverlay.hide();
      }
    });
    _setupData();
  }

  void _setupData() async {
    await _cubit!.getListBank();
  }

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  @override
  void dispose() {
    _showMessageSubscription.cancel();
    _showLoadingSubscription.cancel();
    super.dispose();
  }

  String selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.mainColor, size: 40)),
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 100, 15, 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.icApp,
                            width: 100,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Xin chào!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Vui lòng tạo cửa hàng của bạn để tiếp tục",
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Tên cửa hàng",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: TextFormField(
                            controller: _shopNameController,
                            validator: (value) {
                              if (Validator.validateNullOrEmpty(value!))
                                return "Vui lòng tên cửa hàng";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Tên cửa hàng",
                              hintStyle: const TextStyle(
                                  color: AppColors.textColor, fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(10),
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
                      const Text(
                        "Địa chỉ",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: TextFormField(
                            controller: _shopAddressController,
                            validator: (value) {
                              if (Validator.validateNullOrEmpty(value!))
                                return "Vui lòng nhập địa chỉ";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Địa chỉ",
                              hintStyle: const TextStyle(
                                  color: AppColors.textColor, fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Thông tin về ngân hàng nhận tiền từ khách hàng",
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Ngân hàng",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<ShopCreateCubit, ShopCreateState>(
                        bloc: _cubit,
                        buildWhen: (previous, current) =>
                            previous.listBanks != current.listBanks,
                        builder: (context, state) {
                          return SizedBox(
                            height: 61,
                            child: Center(
                              child: AppAutoComplete(
                                  textFieldController: _bankNameController,
                                  hintText: "Ngân hàng",
                                  onBankSelected: (bank) {
                                    setState(() {
                                      selectedBank = bank;
                                    });
                                  },
                                  suggestions: _cubit?.state.listBanks ?? []),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Số tài khoản",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: TextFormField(
                            scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        250),
                            controller: _accountNumberController,
                            validator: (value) {
                              if (Validator.validateNullOrEmpty(value!))
                                return "Vui lòng nhập số tài khoản";
                              else
                                return null;
                            },
                            onEditingComplete: () {
                              // print(selectedBank!.code);
                              AccountNumberCheck account = AccountNumberCheck(
                                  bin: _bankNameController.text,
                                  accountNumber: _accountNumberController.text);
                              _cubit!.checkAccountName(account);
                            },
                            decoration: InputDecoration(
                              hintText: "Số tài khoản",
                              hintStyle: const TextStyle(
                                  color: AppColors.textColor, fontSize: 14),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Chủ thẻ",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<ShopCreateCubit, ShopCreateState>(
                          buildWhen: (previous, current) =>
                              previous.accountName != current.accountName,
                          bloc: _cubit,
                          builder: (context, state) {
                            if (state.accountName != null) {
                              Future.delayed(Duration.zero, () {
                                _accountNameController.text =
                                    state.accountName!;
                              });
                            }
                            return SizedBox(
                              height: 60,
                              child: Center(
                                child: TextFormField(
                                  controller: _accountNameController,
                                  enabled: false,
                                  validator: (value) {
                                    if (Validator.validateNullOrEmpty(value!))
                                      return "Vui lòng nhập chủ thẻ";
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Chủ thẻ",
                                    hintStyle: const TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                )),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () async {
          // if (_formKey.currentState!.validate()) {

          await _cubit?.createShop(
              _shopNameController.text,
              _shopAddressController.text,
              selectedBank!.shortName.toString(),
              selectedBank!.bin.toString(),
              _accountNumberController.text,
              _accountNameController.text);
          // }
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
