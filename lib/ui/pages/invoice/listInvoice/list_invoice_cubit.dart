import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/entities/invoice/invoice_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'list_invoice_state.dart';

class ListInvoiceCubit extends Cubit<ListInvoiceState> {
  ListInvoiceCubit() : super(ListInvoiceState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> getListInvoices() async {
    showLoading.sink.add(LoadStatus.LOADING);
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      String? shopId = await SharedPreferencesHelper.getShopId();
      FirebaseFirestore.instance
          .collection('invoices')
          .where('shopId', isEqualTo: shopId)
          .orderBy('issuedDate', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        List<InvoiceEntity> listInvoices = querySnapshot.docs
            .map((e) => InvoiceEntity.fromJson(e.data() as Map<String, dynamic>)
              ..id = e.id)
            .toList();
        emit(state.copyWith(listInvoices: listInvoices));
        emit(state.copyWith(loadStatus: LoadStatus.SUCCESS));
        showLoading.sink.add(LoadStatus.SUCCESS);
      });
    } catch (error) {
      print(error);
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      showLoading.sink.add(LoadStatus.FAILURE);
    }
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
