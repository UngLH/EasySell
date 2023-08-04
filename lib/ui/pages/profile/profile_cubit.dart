import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/dtos/product/cart_product_dto.dart';
import 'package:mobile/models/entities/shop/shop_entity.dart';
import 'package:mobile/models/enum/loading_status.dart';
import 'package:mobile/storage/share_preferences_helper.dart';
import 'package:mobile/ui/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());
  final showMessageController = PublishSubject<SnackBarMessage>();
  final showLoading = PublishSubject<LoadStatus>();

  Future<void> logout() async {
    showLoading.sink.add(LoadStatus.LOADING);
    await FirebaseAuth.instance.signOut().then((value) {
      SharedPreferencesHelper.removeUserIdAndEmail();
      showLoading.sink.add(LoadStatus.SUCCESS);
    }).catchError((error) {
      emit(state.copyWith(loadStatus: LoadStatus.FAILURE));
      showLoading.sink.add(LoadStatus.FAILURE);
    });
  }

  Future<void> getShop() async {
    String? userId = await SharedPreferencesHelper.getUserId();
    String? email = await SharedPreferencesHelper.getEmail();
    emit(state.copyWith(email: email));
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

  @override
  Future<void> close() {
    showMessageController.close();
    return super.close();
  }
}
