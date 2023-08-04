import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/dtos/invoice/create_invoice_dto.dart';
import 'package:mobile/models/dtos/product/cart_product_dto.dart';
import 'package:mobile/models/entities/shop/shop_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/models/enum/payment_type.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  SellCubit() : super(SellState());
  final showMessageController = PublishSubject<SnackBarMessage>();

  Future<void> getShop() async {
    String? userId = await SharedPreferencesHelper.getUserId();
    FirebaseFirestore.instance
        .collection('shop')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      Map<String, dynamic> data =
          querySnapshot.docs[0].data() as Map<String, dynamic>;
      ShopEntity shopObject = ShopEntity.fromJson(data);
      emit(state.copyWith(
        shopEntity: shopObject,
      ));
    });
  }

  Future<void> addProductToList(CartProductDTO productDTO) async {
    List<CartProductDTO> updatedList = List.from(state.listCartProduct ?? []);
    bool isExistInList =
        updatedList.any((element) => element.barcode == productDTO.barcode);

    if (isExistInList) {
      updatedList
          .firstWhere((element) => element.barcode == productDTO.barcode)
          .amount += 1;
    } else {
      updatedList.add(productDTO);
    }

    emit(state.copyWith(
        listCartProduct: updatedList, loadStatus: LoadStatus.SUCCESS));
    await calculateTotal();
  }

  Future<void> setAmount(String barcode, num amount) async {
    List<CartProductDTO> updatedList = List.from(state.listCartProduct ?? []);
    for (var element in updatedList) {
      if (element.barcode == barcode) {
        element.amount = amount;
        break;
      }
    }
    emit(state.copyWith(listCartProduct: updatedList));
    await calculateTotal();
  }

  Future<void> adjustAmount(String barcode, num adjustValue) async {
    List<CartProductDTO> updatedList = List.from(state.listCartProduct ?? []);
    for (int i = 0; i < updatedList.length; i++) {
      if (updatedList[i].barcode == barcode) {
        updatedList[i].amount = updatedList[i].amount + adjustValue;
        if (updatedList[i].amount == 0) {
          updatedList.removeAt(i);
        }
        break;
      }
    }
    emit(state.copyWith(listCartProduct: updatedList));
    await calculateTotal();
  }

  Future<void> removeProduct(String barcode) async {
    List<CartProductDTO> updatedList = List.from(state.listCartProduct ?? []);
    for (int i = 0; i < updatedList.length; i++) {
      if (updatedList[i].barcode == barcode) {
        updatedList.removeAt(i);
        break;
      }
    }
    emit(state.copyWith(listCartProduct: updatedList));
    await calculateTotal();
  }

  Future<void> calculateTotal() async {
    List<CartProductDTO> updatedList = List.from(state.listCartProduct ?? []);
    num total = 0;
    for (var product in updatedList) {
      total += (product.amount * (product.sellPrice!));
    }
    emit(state.copyWith(total: total));
  }

  Future<void> getProductEntity(String barcode) async {
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    String? shopId = await SharedPreferencesHelper.getShopId();
    FirebaseFirestore.instance
        .collection('product')
        .where('shopId', isEqualTo: shopId)
        .where('barcode', isEqualTo: barcode)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      List<CartProductDTO> listProduct = querySnapshot.docs
          .map((e) => CartProductDTO.fromJson(e.data() as Map<String, dynamic>)
            ..productId = e.id
            ..amount = 1)
          .toList();
      await addProductToList(listProduct[0]);
    }).catchError((error) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    });
  }

  Future<void> addInvoice(
      List<CartProductDTO>? cardProducts,
      num? totalProducts,
      num? total,
      PaymentType? paymentType,
      String? issuedDate) async {
    String? shopId = await SharedPreferencesHelper.getShopId();
    emit(state.copyWith(loadStatus: LoadStatus.LOADING));
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference invoicesRef = firestore.collection('invoices');
    CreateInvoiceDTO invoiceDTO = CreateInvoiceDTO(
        shopId: shopId,
        cardProducts: cardProducts,
        total: total,
        totalProducts: totalProducts,
        paymentType: paymentType.toString(),
        issuedDate: issuedDate);
    Map<String, dynamic> invoiceJson = invoiceDTO.toJson();
    await invoicesRef.add(invoiceJson).then((value) async {
      await updateAmountProduct(shopId, state.listCartProduct);
    }).catchError((error) {
      print(error);
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
    });
  }

  Future<void> updateAmountProduct(
      String? shopId, List<CartProductDTO>? listProduct) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productRef = firestore.collection('product');
    for (var product in listProduct!) {
      productRef
          .where('shopId', isEqualTo: shopId)
          .where('barcode', isEqualTo: product.barcode)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          double currentAmount =
              (doc.data()! as Map<String, dynamic>)['amount'];
          productRef.doc(doc.id).update({
            'amount': currentAmount - product.amount,
          }).then((_) {
            showMessageController.sink.add(SnackBarMessage(
                message: "Lưu hóa đơn thành công", type: SnackBarType.SUCCESS));
            emit(state.copyWith(
                loadStatus: LoadStatus.SUCCESS, listCartProduct: [], total: 0));
          }).catchError((error) {
            print('Failed to update data: $error');
          });
        });
      }).catchError((error) {
        print('Failed to query data: $error');
      });
    }
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
