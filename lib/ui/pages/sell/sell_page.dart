import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/dtos/product/cart_product_dto.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/models/enum/payment_type.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/product/barcodeScan/barcode_scan_page.dart';
import 'package:mobile/ui/pages/sell/sell_cubit.dart';
import 'package:mobile/ui/widgets/app_button.dart';
import 'package:mobile/ui/widgets/app_input_dialog.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/ui/widgets/app_text_field.dart';
import 'package:mobile/ui/widgets/custome_slidable_widget.dart';
import 'package:mobile/utils/product_utils.dart';
import 'package:mobile/utils/validators.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage>
    with AutomaticKeepAliveClientMixin<SellPage> {
  SellCubit? _cubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showMessageSubscription;
  final _formKey = GlobalKey<FormState>();
  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");
  final _numberFormatter = NumberFormat.decimalPattern();

  final TextEditingController _barcodeController =
      TextEditingController(text: "");
  final TextEditingController _amountModifyController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<SellCubit>(context);
    _cubit?.getShop();
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _showMessageSubscription.cancel();
  }

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  final autoSizeGroup = AutoSizeGroup();
  final _bottomNavIndex = 1;
  final iconList = <String>[
    AppImages.icHome,
    AppImages.icSell,
    AppImages.icManage,
    AppImages.icProfile
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InkWell(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) => _dialogAddByBarcode());
              },
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: const Text(
          "Danh sách sản phẩm",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocBuilder<SellCubit, SellState>(
          bloc: _cubit,
          buildWhen: (previous, current) =>
              previous.loadStatus != current.loadStatus ||
              previous.listCartProduct != current.listCartProduct ||
              previous.total != current.total ||
              previous.shopEntity != current.shopEntity,
          builder: (context, state) {
            if (state.loadStatus == LoadStatus.LOADING) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ));
            } else if (state.loadStatus == LoadStatus.FAILURE) {
              return const Center(
                child: Text("Đã có lỗi xảy ra!"),
              );
            } else if (state.loadStatus == LoadStatus.SUCCESS) {
              return state.listCartProduct!.isNotEmpty
                  ? SafeArea(
                      child: Stack(
                      children: [
                        _buildList(state.listCartProduct),
                        Positioned(
                            bottom: 0, right: 0, left: 0, child: _totalPrice())
                      ],
                    ))
                  : Center(
                      child: Image.asset(
                      AppImages.icEmptyList,
                      width: 100,
                      opacity: const AlwaysStoppedAnimation(.2),
                    ));
            } else {
              return Center(
                  child: Image.asset(
                AppImages.icEmptyList,
                width: 100,
                opacity: const AlwaysStoppedAnimation(.2),
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String barcode = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodeScanPage()),
            );
            setState(() {
              _cubit!.getProductEntity(barcode);
            });
          },
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.asset(AppImages.icAnimatedQR),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconList[index],
                width: 25,
                height: 25,
                color: index == 1 ? AppColors.mainColor : AppColors.textColor,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AutoSizeText(
                  index == 0
                      ? "Home"
                      : (index == 1
                          ? "Sell"
                          : (index == 2 ? "Manage" : "Profile")),
                  maxLines: 1,
                  style: TextStyle(
                      color: index == 1
                          ? AppColors.mainColor
                          : AppColors.textColor,
                      fontWeight: FontWeight.w600),
                  group: autoSizeGroup,
                ),
              )
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) => setState(() {
          if (index == 0) {
            Application.router?.navigateTo(context, Routers.home);
          } else if (index == 1) {
            Application.router?.navigateTo(context, Routers.sell);
          } else if (index == 2) {
            Application.router?.navigateTo(context, Routers.listProduct);
          } else {
            Application.router?.navigateTo(context, Routers.profile);
          }
        }),
        //other params
      ),
    );
  }

  Widget _buildList(List<CartProductDTO>? listCartProduct) {
    if (listCartProduct == null || listCartProduct.isEmpty) {
      return Center(
          child: Image.asset(
        AppImages.icEmptyList,
        width: 100,
        opacity: const AlwaysStoppedAnimation(.2),
      ));
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100, left: 10, right: 10),
      itemCount: listCartProduct.length,
      itemBuilder: (context, index) {
        return cartItems(
            product: listCartProduct[index],
            onUpdate: () async {
              await showDialog(
                  context: context,
                  builder: (context) => _dialogModifyAmount(
                      barcode: listCartProduct[index].barcode));
            },
            onDelete: () async {
              setState(() {
                _cubit!
                    .removeProduct(listCartProduct[index].barcode.toString());
              });
            });
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget _totalPrice() {
    return BlocBuilder<SellCubit, SellState>(
        bloc: _cubit,
        buildWhen: (previous, current) => previous.total != current.total,
        builder: (context, state) {
          return Material(
            color: Colors.white,
            elevation: 0,
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          const Text(
                            "Tổng cộng: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(_currencyFormatter.format(state.total ?? 0),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))),
                                context: context,
                                builder: (context) => FractionallySizedBox(
                                    heightFactor: 0.8,
                                    child: _selectPaymentModal(state.total)));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainColor),
                          child: const Text("Thanh toán"))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _selectPaymentModal(num? total) {
    PaymentType selectPayment = PaymentType.BANKING;
    return BlocBuilder<SellCubit, SellState>(
        buildWhen: (previous, current) =>
            previous.loadStatus != current.loadStatus ||
            previous.listCartProduct != current.listCartProduct ||
            previous.total != current.total ||
            previous.shopEntity != current.shopEntity,
        bloc: _cubit,
        builder: (context, state) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Thanh toán",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tổng cộng:",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              _currencyFormatter.format(total).toString(),
                              style: const TextStyle(
                                  color: AppColors.greenTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Lựa chọn phương thức thanh toán",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                          elevation: selectPayment == PaymentType.CASH ? 5 : 0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: selectPayment == PaymentType.CASH
                                      ? Border.all(color: AppColors.mainColor)
                                      : Border.all(color: AppColors.lineColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                  leading: Image.asset(
                                    AppImages.icCashPayment,
                                    height: 40,
                                  ),
                                  title: const Text(
                                    "Tiền mặt",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      selectPayment = PaymentType.CASH;
                                    });
                                  }))),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: selectPayment == PaymentType.BANKING ? 5 : 0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            decoration: BoxDecoration(
                                border: selectPayment == PaymentType.BANKING
                                    ? Border.all(color: AppColors.mainColor)
                                    : Border.all(color: AppColors.lineColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Image.asset(
                                AppImages.icBankingTransfer,
                                height: 40,
                              ),
                              onTap: () async {
                                setState(() {
                                  selectPayment = PaymentType.BANKING;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title:
                                          const Text("Thông tin chuyển khoản"),
                                      content: Image.network(
                                        "https://img.vietqr.io/image/${state.shopEntity?.bankName}-${state.shopEntity?.accountNumber}-compact2.jpg?amount=${total}&addInfo=Thanh%20toan%20tien%20mua%20hang&accountName=${state.shopEntity?.accountName}",
                                        height: 300,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text(
                                            "Đóng",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // print(state.total);
                                            await _cubit!.addInvoice(
                                                state.listCartProduct,
                                                state.listCartProduct?.length,
                                                state.total,
                                                selectPayment,
                                                DateTime.now().toString());
                                            Navigator.of(dialogContext).pop();
                                            Navigator.of(dialogContext)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text("Xong"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              title: const Text(
                                "Chuyển khoản",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AppButton(
                              color: Colors.red,
                              title: 'Hủy bỏ',
                              width: 80,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: AppButton(
                            color: AppColors.mainColor,
                            title: "Xác nhận",
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            onPressed: () async {
                              await _cubit!.addInvoice(
                                  state.listCartProduct,
                                  state.listCartProduct?.length,
                                  state.total,
                                  selectPayment,
                                  DateTime.now().toString());
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget cartItems(
      {CartProductDTO? product,
      VoidCallback? onUpdate,
      VoidCallback? onDelete}) {
    ProductCategory productCategory =
        ProductUtils.getProductCategoryByCategory(product!.category.toString());
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 1 / 3,
        motion: const BehindMotion(),
        children: [
          CustomSlidableAction(
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {
                onUpdate?.call();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(Icons.border_color_outlined)),
                  SizedBox(height: 4),
                  FittedBox(
                    child: Text('Sửa',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              )),
          CustomSlidable(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {
                onDelete?.call();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Icon(Icons.delete),
                  ),
                  SizedBox(height: 4),
                  FittedBox(
                    child: Text(
                      'Xóa',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              )),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            shape: BoxShape.rectangle,
            border: Border.all(color: AppColors.borderCardColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              productCategory.productImage ?? AppImages.imageDrinkCategory,
              width: 90,
              height: 90,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? "name",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_currencyFormatter.format(product.sellPrice)}/${product.unit}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w500),
                        ),
                        _addButton(Icons.remove_outlined, () {
                          setState(() {
                            _cubit!
                                .adjustAmount(product.barcode.toString(), -1);
                          });
                        }),
                        Text(_numberFormatter.format(product.amount)),
                        _addButton(Icons.add, () {
                          setState(() {
                            _cubit!.adjustAmount(product.barcode.toString(), 1);
                          });
                        })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _currencyFormatter
                            .format(product.sellPrice! * product.amount),
                        style: const TextStyle(
                            color: AppColors.greenTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton(IconData iconData, VoidCallback onTap) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: InkWell(
          onTap: onTap,
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _dialogAddByBarcode() {
    return AppInputDialog(
      title: "Thêm sản phẩm",
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextLabel("Mã vạch: "),
                AppTextField(
                  hintText: "Mã vạch",
                  controller: _barcodeController,
                  validator: (value) {
                    if (Validator.validateNullOrEmpty(value!))
                      return "Vui lòng nhập tên sản phẩm ";
                  },
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),
          ),
        )
      ],
      onConfirm: () async {
        if (_formKey.currentState!.validate()) {
          await _cubit!.getProductEntity(_barcodeController.text);
          Navigator.pop(context);
          setState(() {});
        }
      },
    );
  }

  Widget _dialogModifyAmount({String? barcode}) {
    return AppInputDialog(
      title: "Chỉnh sửa số lượng",
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextLabel("Số lượng: "),
                AppTextField(
                  hintText: "Số lượng",
                  controller: _amountModifyController,
                  validator: (value) {
                    if (Validator.validateNullOrEmpty(value!))
                      return "Vui lòng nhập số lượng ";
                  },
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
              ],
            ),
          ),
        )
      ],
      onConfirm: () async {
        if (_formKey.currentState!.validate()) {
          await _cubit!
              .setAmount(barcode!, double.parse(_amountModifyController.text));
          Navigator.pop(context);
          setState(() {});
        }
      },
    );
  }

  Widget _buildTextLabel(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
