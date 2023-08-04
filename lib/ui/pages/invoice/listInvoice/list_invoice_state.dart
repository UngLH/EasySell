part of 'list_invoice_cubit.dart';

class ListInvoiceState extends Equatable {
  final LoadStatus? loadStatus;
  List<InvoiceEntity>? listInvoices = [];

  ListInvoiceState({this.loadStatus, this.listInvoices});

  ListInvoiceState copyWith(
      {LoadStatus? loadStatus, List<InvoiceEntity>? listInvoices}) {
    return ListInvoiceState(
        loadStatus: loadStatus ?? this.loadStatus,
        listInvoices: listInvoices ?? this.listInvoices);
  }

  @override
  List<Object?> get props => [loadStatus, listInvoices];
}
