import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/entities/product/product_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'list_product_state.dart';

class ListProductCubit extends Cubit<ListProductState> {
  ListProductCubit() : super(ListProductState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> getListProduct(String category) async {
    showLoading.sink.add(LoadStatus.LOADING);
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    FirebaseFirestore.instance
        .collection('product')
        .where('category', isEqualTo: category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<ProductEntity> listProduct = querySnapshot.docs
          .map((e) => ProductEntity.fromJson(e.data() as Map<String, dynamic>)
            ..id = e.id)
          .toList();
      emit(state.copyWith(
          listProduct: listProduct, loadStatus: LoadStatus.SUCCESS));
      showLoading.sink.add(LoadStatus.SUCCESS);
    }).catchError((error) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      showLoading.sink.add(LoadStatus.FAILURE);
    });
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
