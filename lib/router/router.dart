import 'package:fluro/fluro.dart';
import 'package:mobile/router/router_handlers/auth_router_handler.dart';
import 'package:mobile/router/router_handlers/home_router_handler.dart';
import 'package:mobile/router/router_handlers/invoice_router_handler.dart';
import 'package:mobile/router/router_handlers/product_router_handler.dart';
import 'package:mobile/router/router_handlers/root_router_handler.dart';
import 'package:mobile/router/router_handlers/search_router_handler.dart';
import 'package:mobile/router/router_handlers/sell_router_handler.dart';

import 'router_handlers/profile_router_handler.dart';

class Routers {
  static String root = "/";

  /// Auth
  static String login = "/login";
  static String signUp = "/signUp";

  static String createShop = "/createShop";
  //Home
  static String home = '/home';

  ///Product
  static String listProduct = '/listProduct';
  static String addProduct = '/addProduct';
  static String barcodeScan = '/barcodeScan';
  static String detailProduct = '/detailProduct';

  /// Invoice
  static String listInvoice = '/listInvoice';
  static String invoiceDetail = '/invoiceDetail';

  // Sell
  static String sell = "/sell";

  /// Profile
  static String profile = "/profile";

  /// Search
  static String search = "/search";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = notHandler;
    router.define(
      root,
      handler: splashHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      login,
      handler: loginHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      createShop,
      handler: createShopHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      signUp,
      handler: signUpHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      home,
      handler: homeHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Product
    router.define(
      listProduct,
      handler: listProductHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      addProduct,
      handler: addProductHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      barcodeScan,
      handler: barcodeScanHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      detailProduct,
      handler: productDetailHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Invoice
    router.define(
      listInvoice,
      handler: listInvoiceHandler,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      invoiceDetail,
      handler: invoiceDetailHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Profile
    router.define(profile,
        handler: profileHandler, transitionType: TransitionType.fadeIn);

    /// Sell
    router.define(
      sell,
      handler: sellHandler,
      transitionType: TransitionType.fadeIn,
    );

    /// Search
    router.define(search,
        handler: searchHandler, transitionType: TransitionType.fadeIn);
  }
}
