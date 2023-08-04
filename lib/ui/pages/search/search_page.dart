import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/search/search_cubit.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/utils/product_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  SearchCubit? _cubit;
  late StreamSubscription _showMessageSubscription;
  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MobileScannerController cameraController = MobileScannerController();
  bool isShowModal = false;

  @override
  void initState() {
    _cubit = BlocProvider.of<SearchCubit>(context);
    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });
    super.initState();
  }

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  bool barcodeDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            if (!barcodeDetected) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              if (barcodes.isNotEmpty) {
                _cubit?.setBarcode(barcodes[0].rawValue.toString());
                _cubit?.getDetailProduct();
                if (_cubit?.state.showModal == true) {
                  barcodeDetected = true;
                }
              }
            }
          },
        ),
        BlocBuilder<SearchCubit, SearchState>(
            bloc: _cubit,
            buildWhen: (prev, current) => prev.showModal != current.showModal,
            builder: (context, state) {
              if (state.showModal == true) {
                return _infoModal(
                    onClose: () {
                      setState(() {
                        barcodeDetected = false;
                        _cubit!.setShowModal(false);
                      });
                    },
                    onOk: () {
                      Application.router?.navigateTo(
                          context, Routers.detailProduct,
                          routeSettings: RouteSettings(
                              arguments: _cubit?.state.product?.id));
                    },
                    product: state.product);
              } else {
                return SizedBox();
              }
            })
      ],
    );
  }

  Widget _infoModal(
      {VoidCallback? onClose, VoidCallback? onOk, ProductEntity? product}) {
    ProductCategory category = ProductUtils.getProductCategory(product!);
    return Positioned(
      bottom: 30,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 160,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  category.productImage.toString(),
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product?.name ?? "Name",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      _currencyFormatter.format(product?.sellPrice),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.mainColor),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _button(onPressed: onClose, text: "Đóng", background: Colors.red),
              const SizedBox(
                width: 20,
              ),
              _button(
                  onPressed: onOk,
                  text: "Chi tiết",
                  background: AppColors.mainColor)
            ])
          ],
        ),
      ),
    );
  }

  Widget _button(
      {double? width,
      VoidCallback? onPressed,
      String? text,
      Color? background}) {
    return SizedBox(
      width: width ?? 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: background ?? AppColors.mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(text ?? "Button"),
      ),
    );
  }
}
