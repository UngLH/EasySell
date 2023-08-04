import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/product/listProduct/list_product_cubit.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:mobile/ui/widgets/custome_slidable_widget.dart';
import 'package:mobile/utils/product_utils.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductState();
}

class _ListProductState extends State<ListProductPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _showMessageSubscription;
  late StreamSubscription _showLoadingSubscription;
  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");
  final _numberFormatter = NumberFormat.decimalPattern();
  ListProductCubit? _cubit;
  List<CategoryItem> itemList = [
    CategoryItem(
        image: AppImages.vegetableCategory,
        title: 'Rau củ',
        value: "Vegetable"),
    CategoryItem(
        image: AppImages.fruitCategory, title: 'Hoa quả', value: "Fruit"),
    CategoryItem(
        image: AppImages.drinkCategory, title: 'Đồ uống', value: "Drink"),
    CategoryItem(
        image: AppImages.dryFoodCategory,
        title: 'Thực phẩm khô',
        value: "Dry-Food"),
    CategoryItem(
        image: AppImages.snackCategory, title: 'Bánh kẹo', value: "Cake-Candy"),
    CategoryItem(
        image: AppImages.frozenFoodCategory,
        title: 'Đông lạnh',
        value: "Frozen-Food"),
    CategoryItem(
        image: AppImages.icStationery,
        title: 'Văn phòng phẩm',
        value: "Stationery"),
    CategoryItem(
        image: AppImages.icSkincare,
        title: 'Vệ sinh cá nhân',
        value: "Skincare"),
    CategoryItem(
        image: AppImages.chemicalCategory,
        title: 'Hóa phẩm',
        value: "Chemical"),
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<ListProductCubit>(context);
    _cubit?.getListProduct(itemList[selectedIndex].value);

    _showMessageSubscription =
        _cubit!.showMessageController.stream.listen((event) {
      _showMessage(event);
    });

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
    // TODO: implement dispose
    super.dispose();
    _showLoadingSubscription.cancel();
    _showMessageSubscription.cancel();
  }

  bool isShowPassword = false;

  final autoSizeGroup = AutoSizeGroup();
  final _bottomNavIndex = 2;
  final iconList = <String>[
    AppImages.icHome,
    AppImages.icSell,
    AppImages.icManage,
    AppImages.icProfile
  ];

  void _showMessage(SnackBarMessage message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar(message: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.mainColor, size: 40)),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    fillColor: const Color(0xFFF1F1F5),
                                    filled: true,
                                    hintText: "Tìm kiếm sản phẩm",
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          height: 130,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return categoryItem(
                                  isSelected: selectedIndex == index,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      _cubit?.getListProduct(
                                          itemList[selectedIndex].value);
                                    });
                                  },
                                  image: itemList[index].image,
                                  categoryText: itemList[index].title,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  width: 10,
                                );
                              },
                              itemCount: itemList.length)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Danh sách sản phẩm",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          _addButton(),
                        ],
                      ),
                      Expanded(
                        child: BlocBuilder<ListProductCubit, ListProductState>(
                            builder: (context, state) {
                          if (state.loadStatus == LoadStatus.LOADING) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ));
                          } else if (state.loadStatus == LoadStatus.FAILURE) {
                            return Center(
                                child: Image.asset(
                              AppImages.icEmptyList,
                              width: 100,
                              opacity: const AlwaysStoppedAnimation(.2),
                            ));
                          } else {
                            return state.listProduct!.length != 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: state.listProduct?.length ?? 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return productItemCard(
                                            category: state
                                                .listProduct?[index].category,
                                            image: AppImages.imageDrinkCategory,
                                            color: const Color(0xFF4D6FF0)
                                                .withOpacity(0.15),
                                            name:
                                                state.listProduct?[index].name,
                                            price: _currencyFormatter.format(
                                                state.listProduct?[index]
                                                    .sellPrice),
                                            amount: _numberFormatter.format(state
                                                .listProduct?[index].amount),
                                            unit:
                                                state.listProduct?[index].unit,
                                            onCardTap: () => Application.router
                                                ?.navigateTo(context,
                                                    Routers.detailProduct,
                                                    routeSettings: RouteSettings(
                                                        arguments: state
                                                            .listProduct?[index]
                                                            .id)));
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(
                                    AppImages.icEmptyList,
                                    width: 100,
                                    opacity: const AlwaysStoppedAnimation(.2),
                                  ));
                          }
                        }),
                      ),
                    ])),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Application.router?.navigateTo(context, Routers.listInvoice);
          },
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image.asset(
              AppImages.icAnimatedInvoice,
              height: 40,
            ),
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
                color: index == 2 ? AppColors.mainColor : AppColors.textColor,
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
                      color: index == 2
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

  Widget _addButton() {
    return BlocBuilder<ListProductCubit, ListProductState>(
        bloc: _cubit,
        builder: (context, state) {
          return ElevatedButton(
              onPressed: () async {
                bool isSuccess = await Application.router?.navigateTo(
                  context,
                  Routers.addProduct,
                  routeSettings:
                      RouteSettings(arguments: itemList[selectedIndex].value),
                );
                if (isSuccess) {
                  _cubit!.getListProduct(itemList[selectedIndex].value);
                  _cubit!.showMessageController.sink.add(SnackBarMessage(
                    message: "Thêm sản phẩm thành công!",
                    type: SnackBarType.SUCCESS,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Row(
                children: const [
                  Icon(
                    Icons.add,
                    size: 16,
                  ),
                  Text("Thêm"),
                ],
              ));
        });
  }

  Widget productItemCard(
      {String? name,
      String? category,
      String? price,
      String? amount,
      String? unit,
      Color? color,
      String? image,
      VoidCallback? onCardTap}) {
    ProductCategory productCategory =
        ProductUtils.getProductCategoryByCategory(category.toString());
    print(productCategory.categoryText);
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 1 / 3,
        motion: const BehindMotion(),
        children: [
          CustomSlidableAction(
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              onPressed: (BuildContext context) {},
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
              onPressed: (BuildContext context) {},
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
      child: InkWell(
        onTap: onCardTap,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.grayBackground.withOpacity(0.3)),
              child: Row(
                children: [
                  Image.asset(
                    productCategory.productImage ??
                        AppImages.imageDrinkCategory,
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "name",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Đơn giá: $price/$unit" ?? "price/unit",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greenTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Số lượng: $amount $unit",
                          style: const TextStyle(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                ],
              )),
        ),
      ),
    );
  }

  Widget categoryItem(
      {String? image,
      String? categoryText,
      bool? isSelected,
      VoidCallback? onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected == true
                      ? Border.all(color: AppColors.mainColor)
                      : null),
              child: Center(
                child: Image.asset(
                  image ?? AppImages.vegetableCategory,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 80,
          child: Text(
            categoryText ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class CategoryItem {
  final String image;
  final String title;
  final String value;

  CategoryItem({required this.image, required this.title, required this.value});
}
