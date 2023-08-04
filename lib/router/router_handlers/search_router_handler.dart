import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/search/search_cubit.dart';
import 'package:mobile/ui/pages/search/search_page.dart';

Handler searchHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return SearchCubit();
    },
    child: const SearchPage(),
  );
});
