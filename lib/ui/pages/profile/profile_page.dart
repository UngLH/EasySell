import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/pages/profile/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  ProfileCubit? _cubit;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showLoadingSubscription;
  String? email;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ProfileCubit>(context);
    _setupData();
    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else if (status == LoadStatus.SUCCESS) {
        context.loaderOverlay.hide();
        Application.router
            ?.navigateTo(context, Routers.login, clearStack: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _showLoadingSubscription.cancel();
  }

  void _setupData() async {
    _cubit?.getShop();
    email = await SharedPreferencesHelper.getEmail();
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
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.mainColor, size: 40)),
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: _buildBody()),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {},
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
                color: index == 3 ? AppColors.mainColor : AppColors.textColor,
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
                      color: index == 3
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

  Widget _buildBody() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: _cubit,
      buildWhen: (previous, current) =>
          previous.shopEntity != current.shopEntity ||
          previous.email != current.email,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(AppImages.icUser)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Email: ${state.email}",
                    style: const TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tên cửa hàng:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(state.shopEntity?.name ?? "")
                ],
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Địa chỉ: ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(state.shopEntity?.address ?? "")
                ],
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ngân hàng ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(state.shopEntity?.bankName ?? "")
                ],
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Số tài khoản: ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(state.shopEntity?.accountNumber ?? "")
                ],
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chủ tài khoản ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(state.shopEntity?.accountName ?? "")
                ],
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
            ListTile(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text('Đăng xuất'),
                            content:
                                const Text('Bạn có chắc chắn muốn đăng xuất?"'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Hủy'),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _cubit!.logout();
                                },
                                child: const Text('Xác nhận'),
                              ),
                            ]));
              },
              title: const Text("Đăng xuất",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
            const Divider(
              color: AppColors.lineColor,
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
