import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/ui/pages/product/addProduct/add_product_cubit.dart';
import 'package:mobile/ui/pages/product/barcodeScan/barcode_scan_page.dart';
import 'package:mobile/ui/widgets/app_bar_widget.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/utils/formater.dart';
import 'package:mobile/utils/validators.dart';

class AddProductPage extends StatefulWidget {
  String? category;

  AddProductPage({Key? key, this.category}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductState();
}

class _AddProductState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showLoadingSubscription;
  late StreamSubscription _showMessageSubscription;
  final _productNameController = TextEditingController(text: '');
  final _amountController = TextEditingController(text: '');
  final _manufacturingDateController = TextEditingController(text: '');
  final _expiredDateController = TextEditingController(text: '');
  final _costPriceController = TextEditingController(text: '');
  final _sellPriceController = TextEditingController(text: '');

  final _barcodeController = TextEditingController(text: '');
  AddProductCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<AddProductCubit>(context);
    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else if (status == LoadStatus.SUCCESS) {
        context.loaderOverlay.hide();
        Navigator.of(context).pop(true);
      } else {
        context.loaderOverlay.hide();
      }
    });
    _showMessageSubscription = _cubit!.showMessageController.stream
        .listen((even) => _showMessage(even));
  }

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  @override
  void dispose() {
    _showLoadingSubscription.cancel();
    _showMessageSubscription.cancel();
    super.dispose();
  }

  String? _selectedItem;
  final List<String> _dropdownItems = <String>[
    'Kg',
    'Gram',
    'Lít',
    'Mililit',
    'Cái',
    'Hộp',
    'Lon',
    'Gói',
    'Chai',
    'Quyển'
  ];
  DateTime? _selectedDate;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controller.text =
            Formater.AppDateFormat(DateTime.parse(_selectedDate.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        context: context,
        title: "Thêm sản phẩm",
        onBackPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
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
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
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
                            width: 150,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Vui lòng nhập thông tin của sản phẩm",
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Tên sản phẩm",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: TextFormField(
                            controller: _productNameController,
                            validator: (value) {
                              if (Validator.validateNullOrEmpty(value!))
                                return "Vui lòng tên sản phẩm";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Tên sản phẩm",
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Số lượng",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _amountController,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng nhập số lượng";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Số lượng",
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
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Đơn vị",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedItem,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItem = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Đơn vị",
                                      hintStyle: const TextStyle(
                                          color: AppColors.textColor,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.mainColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: _dropdownItems.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ngày sản xuất",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: TextFormField(
                                    controller: _manufacturingDateController,
                                    decoration: InputDecoration(
                                      hintText: "Ngày sản xuất",
                                      suffixIcon: InkWell(
                                        onTap: () => _selectDate(context,
                                            _manufacturingDateController),
                                        child: Icon(Icons.calendar_month),
                                      ),
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
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hạn sử dụng",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: TextFormField(
                                    controller: _expiredDateController,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng chọn ngày hết hạn";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Hạn sử dụng",
                                      suffixIcon: InkWell(
                                        onTap: () => _selectDate(
                                            context, _expiredDateController),
                                        child: const Icon(Icons.calendar_month),
                                      ),
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
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Giá nhập",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _costPriceController,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng nhập vào giá nhập";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Giá nhập",
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
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Giá bán",
                                style: TextStyle(color: AppColors.textColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        2,
                                child: Center(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _sellPriceController,
                                    validator: (value) {
                                      if (Validator.validateNullOrEmpty(value!))
                                        return "Vui lòng nhập giá bán";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Giá bán",
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
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Mã vạch",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: TextFormField(
                            controller: _barcodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (Validator.validateNullOrEmpty(value!))
                                return "Vui lòng nhập mã vạch";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Mã vạch",
                              suffixIcon: InkWell(
                                splashColor: Colors.white,
                                onTap: () async {
                                  String barcode = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BarcodeScanPage()),
                                  );
                                  setState(() {
                                    _barcodeController.text = barcode;
                                  });
                                },
                                child: const Icon(Icons.camera_alt_rounded),
                              ),
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
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _cubit?.createProduct(
                                        _barcodeController.text,
                                        widget.category,
                                        _productNameController.text,
                                        double.parse(_amountController.text),
                                        _selectedItem,
                                        _manufacturingDateController.text,
                                        _expiredDateController.text,
                                        int.parse(_costPriceController.text),
                                        int.parse(_sellPriceController.text));
                                  }
                                },
                                child: const Text(
                                  "Thêm",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )),
                          )),
                        ],
                      ),
                    ],
                  ),
                )),
          )),
      // floatingActionButton: BlocBuilder<ShopCreateCubit, ShopCreateState>(
      //   bloc: _cubit,
      //   builder: (context, state) {
      //     return FloatingActionButton(
      //       backgroundColor: AppColors.mainColor,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //       onPressed: () async {
      //         await _cubit?.createShop(
      //             _shopNameController.text, _shopAddressController.text);
      //       },
      //       child: Icon(Icons.navigate_next),
      //     );
      //   },
      // ),
    );
  }
}
