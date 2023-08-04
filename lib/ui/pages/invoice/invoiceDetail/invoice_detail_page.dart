import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/dtos/product/cart_product_dto.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/ui/pages/invoice/invoiceDetail/invoice_detail_cubit.dart';
import 'package:mobile/ui/widgets/app_bar_widget.dart';
import 'package:mobile/utils/product_utils.dart';

class InvoiceDetailPage extends StatefulWidget {
  String invoiceId;

  InvoiceDetailPage({super.key, required this.invoiceId});

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  InvoiceDetailCubit? _cubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showLoadingSubscription;
  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<InvoiceDetailCubit>(context);
    _cubit!.getInvoiceDetail(widget.invoiceId);
    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _showLoadingSubscription.cancel();
  }

  final autoSizeGroup = AutoSizeGroup();
  final iconList = <String>[
    AppImages.icHome,
    AppImages.icSell,
    AppImages.icManage,
    AppImages.icProfile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.mainColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        showBackButton: true,
        title: "Chi tiết hóa đơn",
        textColor: Colors.white,
        iconColor: Colors.white,
        context: context,
        backgroundColor: AppColors.mainColor,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return BlocBuilder<InvoiceDetailCubit, InvoiceDetailState>(
        bloc: _cubit,
        buildWhen: (prev, current) => prev.invoice != current.invoice,
        builder: (context, state) {
          final widthScreen = MediaQuery.of(context).size.width;
          if (state.loadStatus == LoadStatus.LOADING) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          } else if (state.loadStatus == LoadStatus.FAILURE) {
            return const Center(child: Text("Đã có lỗi xảy ra!"));
          } else {
            return LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.mainColor, size: 40)),
                overlayColor: Colors.black,
                overlayOpacity: 0.8,
                child: Center(
                    child: Column(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Tổng hóa đơn",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _currencyFormatter.format(state.invoice?.total),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Ngày phát hành",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    dateFormat.format(DateTime.parse(
                                        state.invoice!.issuedDate.toString())),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Phương thức thanh toán",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Chuyển khoản",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    Flexible(
                        flex: 3,
                        child: Container(
                          width: widthScreen,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Danh sách sản phẩm",
                                    style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  state.invoice!.cardProducts!.isNotEmpty
                                      ? ListView.separated(
                                          itemBuilder: (context, index) {
                                            CartProductDTO product = state
                                                .invoice!.cardProducts![index];
                                            return cartItems(product: product);
                                          },
                                          shrinkWrap: true,
                                          separatorBuilder: (context, state) {
                                            return SizedBox(height: 10);
                                          },
                                          itemCount: state
                                              .invoice!.cardProducts!.length)
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ))
                  ],
                )));
          }
        });
  }

  Widget cartItems({CartProductDTO? product}) {
    ProductCategory productCategory =
        ProductUtils.getProductCategoryByCategory(product!.category.toString());
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
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
                  Text("Số lượng: ${product.amount}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "${_currencyFormatter.format(product.sellPrice)}/${product.unit}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w500)),
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
        ));
  }
}
