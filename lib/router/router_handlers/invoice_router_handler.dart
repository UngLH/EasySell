import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/pages/invoice/invoiceDetail/invoice_detail_cubit.dart';
import 'package:mobile/ui/pages/invoice/invoiceDetail/invoice_detail_page.dart';
import 'package:mobile/ui/pages/invoice/listInvoice/list_invoice_cubit.dart';
import 'package:mobile/ui/pages/invoice/listInvoice/list_invoice_page.dart';

Handler listInvoiceHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return BlocProvider(
    create: (context) {
      return ListInvoiceCubit();
    },
    child: ListInvoicePage(),
  );
});
Handler invoiceDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String invoiceId = context!.settings!.arguments as String;
  return BlocProvider(
    create: (context) {
      return InvoiceDetailCubit();
    },
    child: InvoiceDetailPage(invoiceId: invoiceId),
  );
});
