import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/profile/profile_cubit.dart';
import 'package:mobile/ui/pages/profile/profile_page.dart';

Handler profileHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return ProfileCubit();
    },
    child: const ProfilePage(),
  );
});
