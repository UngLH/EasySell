import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/entities/invoice/invoice_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'invoice_detail_state.dart';

class InvoiceDetailCubit extends Cubit<InvoiceDetailState> {
  InvoiceDetailCubit() : super(InvoiceDetailState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> getInvoiceDetail(String id) async {
    showLoading.sink.add(LoadStatus.LOADING);
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('invoices').doc(id).get();
      if (snapshot.exists) {
        print(snapshot.data);
        InvoiceEntity invoice =
            InvoiceEntity.fromJson(snapshot.data() as Map<String, dynamic>);
        invoice.id = snapshot.id;
        emit(state.copyWith(invoice: invoice, loadStatus: LoadStatus.SUCCESS));
        showLoading.sink.add(LoadStatus.SUCCESS);
      } else {
        emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
        showLoading.sink.add(LoadStatus.FAILURE);
      }
    } catch (e) {
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
