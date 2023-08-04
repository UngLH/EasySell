import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/dtos/product/create_product_dto.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(const AddProductState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> createProduct(
    String? barcode,
    String? category,
    String? name,
    double? amount,
    String? unit,
    String? manufacturingDate,
    String? expiredDate,
    num? costPrice,
    num? sellPrice,
  ) async {
    String? shopId = await SharedPreferencesHelper.getShopId();
    if (await checkExistProduct(shopId, barcode)) {
      showMessageController.sink.add(SnackBarMessage(
          message: "Mã vạch này đã tồn tại!", type: SnackBarType.ERROR));
    } else {
      final shopCreateRef = FirebaseFirestore.instance
          .collection('product')
          .withConverter<CreateProductDTO>(
            fromFirestore: (snapshot, _) =>
                CreateProductDTO.fromJson(snapshot.data()!),
            toFirestore: (shop, _) => shop.toJson(),
          );
      showLoading.sink.add(LoadStatus.LOADING);
      await shopCreateRef
          .add(CreateProductDTO(
              shopId: shopId,
              barcode: barcode,
              category: category,
              name: name,
              amount: amount,
              unit: unit,
              manufacturingDate: manufacturingDate,
              expiredDate: expiredDate,
              sellPrice: sellPrice,
              costPrice: costPrice))
          .then((value) => showLoading.sink.add(LoadStatus.SUCCESS))
          .catchError((error) {
        showLoading.sink.add(LoadStatus.FAILURE);
      });
    }
  }

  Future<bool> checkExistProduct(String? shopId, String? productBarcode) async {
    bool isExist = false;
    await FirebaseFirestore.instance
        .collection('product')
        .where('barcode', isEqualTo: productBarcode)
        .where('shopId', isEqualTo: shopId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        isExist = false;
      } else {
        isExist = true;
      }
    });
    return isExist;
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
