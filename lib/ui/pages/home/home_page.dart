import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/home/home_cubit.dart';
import 'package:mobile/utils/product_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<HomeCubit>(context);
    _cubit?.getListProduct();
  }

  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");
  final _numberFormatter = NumberFormat.decimalPattern();

  final autoSizeGroup = AutoSizeGroup();
  final _bottomNavIndex = 0;
  final iconList = <String>[
    AppImages.icHome,
    AppImages.icSell,
    AppImages.icManage,
    AppImages.icProfile
  ];
  List<CategoryItem> itemList = [
    CategoryItem(image: AppImages.vegetableCategory, title: 'Rau củ'),
    CategoryItem(image: AppImages.fruitCategory, title: 'Hoa quả'),
    CategoryItem(image: AppImages.drinkCategory, title: 'Đồ uống'),
    CategoryItem(image: AppImages.dryFoodCategory, title: 'Thực phẩm khô'),
    CategoryItem(image: AppImages.snackCategory, title: 'Bánh kẹo'),
    CategoryItem(image: AppImages.frozenFoodCategory, title: 'Đông lạnh'),
    CategoryItem(image: AppImages.icSkincare, title: 'Vệ sinh cá nhân'),
    CategoryItem(image: AppImages.chemicalCategory, title: 'Hóa phẩm'),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 20) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      const Text(
                        "Cửa hàng của bạn",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Cửa hàng số 1",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Phân loại",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: itemList.map((CategoryItem item) {
                        return categoryItem(
                            image: item.image, categoryText: item.title);
                      }).toList(),
                    ),
                  ),
                  const Text(
                    "Các sản phẩm bán chạy",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: BlocBuilder<HomeCubit, HomeState>(
                        bloc: _cubit,
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
                            return state.products!.length != 0
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return bestSellingCard(
                                          state.products![index], () {
                                        Application.router?.navigateTo(
                                            context, Routers.detailProduct,
                                            routeSettings: RouteSettings(
                                                arguments:
                                                    state.products![index].id));
                                      });
                                    },
                                    itemCount: state.products!.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 22,
                                            mainAxisSpacing: 28,
                                            childAspectRatio: 0.84),
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
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Application.router?.navigateTo(context, Routers.search);
            // if (barcode) {}
          },
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
                color: index == 0 ? AppColors.mainColor : AppColors.textColor,
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
                      color: index == 0
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

  Widget bestSellingCard(ProductEntity product, VoidCallback onTap) {
    ProductCategory category = ProductUtils.getProductCategory(product);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.grayBackground.withOpacity(0.3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              category.productImage.toString(),
              width: 90,
              height: 90,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "${_currencyFormatter.format(product.sellPrice)}/${product.unit}" ??
                      "price/unit",
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greenTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              product.name ?? "name",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              category.categoryText.toString(),
              style: const TextStyle(
                  color: AppColors.textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem({String? image, String? categoryText}) {
    return Column(
      children: [
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Image.asset(
                image ?? AppImages.vegetableCategory,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          categoryText ?? "",
          style: const TextStyle(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class CategoryItem {
  final String image;
  final String title;

  CategoryItem({required this.image, required this.title});
}
