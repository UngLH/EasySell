part of 'invoice_detail_cubit.dart';

class InvoiceDetailState extends Equatable {
  final LoadStatus? loadStatus;
  InvoiceEntity? invoice;

  InvoiceDetailState({this.loadStatus, this.invoice});

  InvoiceDetailState copyWith(
      {LoadStatus? loadStatus, InvoiceEntity? invoice}) {
    return InvoiceDetailState(
        loadStatus: loadStatus ?? this.loadStatus,
        invoice: invoice ?? this.invoice);
  }

  @override
  List<Object?> get props => [loadStatus, invoice];
}
