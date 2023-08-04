part of 'sell_cubit.dart';

class SellState extends Equatable {
  final LoadStatus? loadStatus;
  final ShopEntity? shopEntity;
  List<CartProductDTO>? listCartProduct;
  final num? total;

  SellState(
      {this.loadStatus, this.shopEntity, this.listCartProduct, this.total});

  SellState copyWith(
      {LoadStatus? loadStatus,
      ShopEntity? shopEntity,
      List<CartProductDTO>? listCartProduct,
      num? total}) {
    return SellState(
        loadStatus: loadStatus ?? this.loadStatus,
        shopEntity: shopEntity ?? this.shopEntity,
        listCartProduct: listCartProduct ?? this.listCartProduct,
        total: total ?? this.total);
  }

  @override
  List<Object?> get props => [loadStatus, shopEntity, listCartProduct, total];
}
