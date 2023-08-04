import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile/commons/app_colors.dart';
import 'package:mobile/commons/app_images.dart';
import 'package:mobile/models/entities/invoice/invoice_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/models/enum/payment_type.dart';
import 'package:mobile/router/application.dart';
import 'package:mobile/router/router.dart';
import 'package:mobile/ui/pages/invoice/listInvoice/list_invoice_cubit.dart';
import 'package:mobile/ui/widgets/app_bar_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile/utils/formater.dart';

class ListInvoicePage extends StatefulWidget {
  const ListInvoicePage({super.key});

  @override
  State<ListInvoicePage> createState() => _ListInvoicePageState();
}

class _ListInvoicePageState extends State<ListInvoicePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _fromDateController = TextEditingController(text: '');
  final _toDateController = TextEditingController(text: '');
  ListInvoiceCubit? _cubit;
  late StreamSubscription _showLoadingSubscription;
  final DateFormat dateFormat = DateFormat('MM:HH dd/MM/yy');

  final _currencyFormatter =
      NumberFormat.currency(locale: "Vi", symbol: "Đồng");

  @override
  void initState() {
    _cubit = BlocProvider.of<ListInvoiceCubit>(context);
    _cubit!.getListInvoices();
    _showLoadingSubscription = _cubit!.showLoading.stream.listen((status) {
      if (status == LoadStatus.LOADING) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _showLoadingSubscription.cancel();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        controller.text =
            Formater.AppDateFormat(DateTime.parse(_selectedDate.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF9F8F7),
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          context: context,
          title: "Danh sách hóa đơn",
          onBackPressed: () {
            Navigator.of(context).pop(false);
          },
          rightActions: [
            IconButton(
                onPressed: _openDrawer,
                icon: const Icon(
                  Icons.tune_outlined,
                  color: Colors.black,
                )),
          ],
        ),
        endDrawer: Drawer(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
                child: Text(
              "Bộ lọc",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            const Divider(
              color: AppColors.lineColor,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Từ ngày "),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: TextFormField(
              controller: _fromDateController,
              decoration: InputDecoration(
                hintText: "Từ ngày",
                suffixIcon: InkWell(
                  onTap: () => _selectDate(context, _fromDateController),
                  child: const Icon(Icons.calendar_month),
                ),
                hintStyle:
                    const TextStyle(color: AppColors.textColor, fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            const Text("Đến ngày"),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: TextFormField(
              controller: _toDateController,
              decoration: InputDecoration(
                hintText: "Đến ngày",
                suffixIcon: InkWell(
                  onTap: () => _selectDate(context, _toDateController),
                  child: const Icon(Icons.calendar_month),
                ),
                hintStyle:
                    const TextStyle(color: AppColors.textColor, fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
          ],
        )),
        body: LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.mainColor, size: 40)),
            overlayColor: Colors.black,
            overlayOpacity: 0.8,
            child: BlocBuilder<ListInvoiceCubit, ListInvoiceState>(
                buildWhen: (previous, current) =>
                    previous.loadStatus != current.loadStatus ||
                    previous.listInvoices != current.listInvoices,
                builder: (context, state) {
                  if (state.loadStatus == LoadStatus.LOADING) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ));
                  } else if (state.loadStatus == LoadStatus.FAILURE) {
                    return Center(
                        child: Image.asset(
                      AppImages.icEmptyList,
                      width: 100,
                      opacity: const AlwaysStoppedAnimation(.2),
                    ));
                  } else {
                    return state.listInvoices!.length != 0
                        ? ListView.separated(
                            itemCount: state.listInvoices!.length,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            itemBuilder: (context, index) {
                              return _billItem(state.listInvoices![index]);
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          )
                        : Center(
                            child: Image.asset(
                            AppImages.icEmptyList,
                            width: 100,
                            opacity: const AlwaysStoppedAnimation(.2),
                          ));
                  }
                })));
  }

  Widget _billItem(InvoiceEntity? invoiceEntity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        onTap: () {
          Application.router!.navigateTo(context, Routers.invoiceDetail,
              routeSettings: RouteSettings(arguments: invoiceEntity?.id));
        },
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), //<-- SEE HERE
        ),
        tileColor: Colors.white,
        leading: Image.asset(AppImages.icBill),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoiceEntity?.id ?? "",
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                dateFormat
                    .format(DateTime.parse(invoiceEntity?.issuedDate ?? "")),
                style: const TextStyle(color: AppColors.textColor),
              )
            ],
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _currencyFormatter.format(invoiceEntity?.total),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenSuccessColor),
                ),
                invoiceEntity?.paymentType == PaymentType.BANKING.toString()
                    ? const Text(
                        "Chuyển khoản",
                        style: TextStyle(color: AppColors.mainColor),
                      )
                    : const Text(
                        "Tiền mặt",
                        style: TextStyle(color: AppColors.yellowMainColor),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
