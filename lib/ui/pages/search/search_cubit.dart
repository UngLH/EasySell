import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/models/dtos/product/create_product_dto.dart';
import 'package:mobile/models/entities/loading/load_entity.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  void setBarcode(String barcode) {
    emit(state.copyWith(barcode: barcode));
  }

  void setShowModal(bool? status) {
    emit(state.copyWith(showModal: status));
  }

  Future<void> getDetailProduct() async {
    String? shopId = await SharedPreferencesHelper.getShopId();
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('product')
          .where('shopId', isEqualTo: shopId)
          .where('barcode', isEqualTo: state.barcode)
          .get();
      if (productSnapshot.docs.isNotEmpty) {
        var productData = productSnapshot.docs[0].data();
        emit(state.copyWith(
            product: ProductEntity.fromJson(productData as Map<String, dynamic>)
              ..id = productSnapshot.docs[0].id));
        setShowModal(true);
      } else {
        showMessageController.sink.add(SnackBarMessage(
            message: "Không tìm thấy sản phẩm!", type: SnackBarType.ERROR));
      }
    } catch (error) {
      showMessageController.sink.add(SnackBarMessage(
          message: "Không tìm thấy sản phẩm!", type: SnackBarType.ERROR));
    }
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
