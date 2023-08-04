import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/app_cubit.dart';
import 'package:mobile/blocs/navigation/navigation_cubit.dart';
import 'package:mobile/commons/app_themes.dart';
import 'package:mobile/configs/app_configs.dart';
import 'package:mobile/networks/api_util.dart';
import 'package:mobile/networks/api_vietqr.dart';
import 'package:mobile/repositories/bank_repository.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/navigation_observer.dart';
import 'package:mobile/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/ui/pages/invoice/invoiceDetail/invoice_detail_page.dart';
import 'package:mobile/ui/pages/search/search_page.dart';
import 'package:mobile/ui/pages/sell/sell_cubit.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'ui/pages/product/detailProduct/detail_product_page.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp() {
    final router = FluroRouter();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  NavigationCubit? _navigationCubit;
  ApiVietQRBank? _apiVietQRBank;

  @override
  void initState() {
    super.initState();
    _apiVietQRBank = ApiUtil.getApiVietQR();
    _navigationCubit = NavigationCubit();
  }

  @override
  void dispose() {
    _navigationCubit!.close();
    // _dynamicConfigCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BankRepository>(create: (context) {
            return BankRepositoryImpl(_apiVietQRBank);
          })
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppCubit>(create: (context) {
              return AppCubit();
            }),
            BlocProvider<NavigationCubit>(
                create: (context) => _navigationCubit!),

            BlocProvider<SellCubit>(create: (context) => SellCubit()),

            // BlocProvider<DynamicConfigCubit>(
            //     create: (context) => _dynamicConfigCubit),
          ],
          child: BlocListener<AppCubit, AppState>(
            listener: (context, state) {},
            child: OverlaySupport(child: materialApp()),
          ),
          // child: materialApp(),
        ));
  }

  GetMaterialApp materialApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      title: AppConfig.appName,
      //đã sửa hardcode
      theme: AppThemes.theme,
      onGenerateRoute: Application.router!.generator,
      initialRoute: Routers.root,
      // home: const SearchPage(),
      navigatorObservers: <NavigatorObserver>[
        NavigationObserver(navigationCubit: _navigationCubit),
      ],

      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // When running in iOS, dismiss the keyboard when any Tap happens outside a TextField
            /*if (Platform.isIOS) */ hideKeyboard(context);
          },
          child: MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          ),
        );
      },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
