import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/product/addProduct/add_product_cubit.dart';
import 'package:mobile/ui/pages/product/addProduct/add_product_page.dart';
import 'package:mobile/ui/pages/product/barcodeScan/barcode_scan_page.dart';
import 'package:mobile/ui/pages/product/detailProduct/detail_product_cubit.dart';
import 'package:mobile/ui/pages/product/detailProduct/detail_product_page.dart';
import 'package:mobile/ui/pages/product/listProduct/list_product_cubit.dart';
import 'package:mobile/ui/pages/product/listProduct/list_product_page.dart';

Handler listProductHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return ListProductCubit();
    },
    child: const ListProductPage(),
  );
});
Handler addProductHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String category = context!.settings!.arguments as String;
  return BlocProvider(
    create: (context) {
      return AddProductCubit();
    },
    child: AddProductPage(
      category: category,
    ),
  );
});

Handler barcodeScanHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) =>
      const BarcodeScanPage(),
);

Handler productDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String productId = context!.settings!.arguments as String;
  return BlocProvider(
    create: (context) {
      return DetailProductCubit();
    },
    child: DetailProductPage(
      productId: productId,
    ),
  );
});
