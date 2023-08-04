import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/sell/sell_cubit.dart';
import 'package:mobile/ui/pages/sell/sell_page.dart';

Handler sellHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return SellCubit();
    },
    child: SellPage(),
  );
});
