import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/models/dtos/product/create_product_dto.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'detail_product_state.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  DetailProductCubit() : super(const DetailProductState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> getDetailProduct(String productId) async {
    showLoading.sink.add(LoadStatus.LOADING);
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('product')
          .doc(productId)
          .get();
      if (productSnapshot.exists) {
        emit(state.copyWith(
            product: ProductEntity.fromJson(
                productSnapshot.data() as Map<String, dynamic>)));
        showLoading.sink.add(LoadStatus.SUCCESS);
      } else {
        print('Product not found.');
      }
    } catch (error) {
      print('Failed to retrieve product: $error');
    }
  }

  Future<void> updateProduct(ProductEntity product) async {
    FirebaseFirestore.instance
        .collection('product')
        .doc(product.id)
        .update(product.toJson())
        .then((_) {
      getDetailProduct(product.id.toString());
    }).catchError((error) {
      print('Failed to update data: $error');
    });
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
