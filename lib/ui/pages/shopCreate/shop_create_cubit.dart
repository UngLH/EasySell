import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/models/dtos/bank/account_number_check.dart';
import 'package:mobile/models/dtos/shop/shop_create_dto.dart';
import 'package:mobile/models/entities/shop/bank_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/repositories/bank_repository.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'shop_create_state.dart';

class ShopCreateCubit extends Cubit<ShopCreateState> {
  BankRepository? bankRepository;

  ShopCreateCubit({this.bankRepository}) : super(const ShopCreateState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();
  final shopCreateRef = FirebaseFirestore.instance
      .collection('shop')
      .withConverter<ShopCreateDTO>(
        fromFirestore: (snapshot, _) =>
            ShopCreateDTO.fromJson(snapshot.data()!),
        toFirestore: (shop, _) => shop.toJson(),
      );

  Future<void> createShop(String shopName, String shopAddress, String bankName,
      String bankBinCode, String accountNumber, String accountName) async {
    String? userId = await SharedPreferencesHelper.getUserId();
    showLoading.sink.add(LoadStatus.LOADING);
    await shopCreateRef
        .add(ShopCreateDTO(
            userId: userId,
            name: shopName,
            address: shopAddress,
            bankName: bankName,
            bankBinCode: bankBinCode,
            accountNumber: accountNumber,
            accountName: accountName))
        .then((value) =>
            showLoading.sink.add(LoadStatus.LOAD_SUCCESS_AND_NAVIGATE))
        .catchError((error) {
      showLoading.sink.add(LoadStatus.FAILURE);
    });
  }

  Future<void> getListBank() async {
    try {
      final response = await bankRepository?.getListBanks();
      if (response != null) {
        final data = response.data;
        emit(state.copyWith(listBanks: data));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAccountName(AccountNumberCheck data) async {
    showLoading.sink.add(LoadStatus.LOADING);
    try {
      final response = await bankRepository?.checkAccountNumber(data);
      if (response != null) {
        final data = response.data;
        print(data?.accountName);
        emit(state.copyWith(accountName: data?.accountName));
        showLoading.sink.add(LoadStatus.SUCCESS);
      } else {
        showMessageController.sink.add(SnackBarMessage(
            message: "Không tìm thấy tài khoàn này", type: SnackBarType.ERROR));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
