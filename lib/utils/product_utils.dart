import 'package:intl/intl.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/entities/product/product_entity.dart';

class ProductUtils {
  static ProductCategory getProductCategory(ProductEntity product) {
    String categoryText = "";
    String productImage = "";
    switch (product.category) {
      case "Vegetable":
        categoryText = "Rau củ";
        productImage = AppImages.vegetableCategory;
        break;
      case "Fruit":
        categoryText = "Hoa quả";
        productImage = AppImages.fruitCategory;
        break;
      case "Drink":
        categoryText = "Đồ uống";
        productImage = AppImages.drinkCategory;
        break;
      case "Dry-Food":
        categoryText = "Thực phẩm khô";
        productImage = AppImages.dryFoodCategory;
        break;
      case "Cake-Candy":
        categoryText = "Bánh kẹo";
        productImage = AppImages.snackCategory;
        break;
      case "Frozen-Food":
        categoryText = "Hoa quả";
        productImage = AppImages.frozenFoodCategory;
        break;
      case "Stationery":
        categoryText = "Văn phòng phẩm";
        productImage = AppImages.icStationery;
        break;
      case "Skincare":
        categoryText = "Vệ sinh cá nhân";
        productImage = AppImages.icSkincare;
        break;
      case "Chemical":
        categoryText = "Hóa phẩm";
        productImage = AppImages.chemicalCategory;
        break;
    }
    return ProductCategory(
        categoryText: categoryText, productImage: productImage);
  }

  static ProductCategory getProductCategoryByCategory(String category) {
    String categoryText = "";
    String productImage = "";
    switch (category) {
      case "Vegetable":
        categoryText = "Rau củ";
        productImage = AppImages.vegetableCategory;
        break;
      case "Fruit":
        categoryText = "Hoa quả";
        productImage = AppImages.fruitCategory;
        break;
      case "Drink":
        categoryText = "Đồ uống";
        productImage = AppImages.drinkCategory;
        break;
      case "Dry-Food":
        categoryText = "Thực phẩm khô";
        productImage = AppImages.dryFoodCategory;
        break;
      case "Cake-Candy":
        categoryText = "Bánh kẹo";
        productImage = AppImages.snackCategory;
        break;
      case "Frozen-Food":
        categoryText = "Hoa quả";
        productImage = AppImages.frozenFoodCategory;
        break;
      case "Stationery":
        categoryText = "Văn phòng phẩm";
        productImage = AppImages.icStationery;
        break;
      case "Skincare":
        categoryText = "Vệ sinh cá nhân";
        productImage = AppImages.icSkincare;
        break;
      case "Chemical":
        categoryText = "Hóa phẩm";
        productImage = AppImages.chemicalCategory;
        break;
    }
    return ProductCategory(
        categoryText: categoryText, productImage: productImage);
  }
}

class ProductCategory {
  String? categoryText;
  String? productImage;

  ProductCategory({this.productImage, this.categoryText});
}
