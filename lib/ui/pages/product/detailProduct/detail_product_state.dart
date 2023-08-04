part of 'detail_product_cubit.dart';

class DetailProductState extends Equatable {
  final LoadStatus? loadStatus;
  final ProductEntity? product;

  const DetailProductState({this.loadStatus, this.product});

  DetailProductState copyWith(
      {LoadStatus? loadStatus, ProductEntity? product}) {
    return DetailProductState(
        loadStatus: loadStatus ?? this.loadStatus,
        product: product ?? this.product);
  }

  @override
  List<Object?> get props => [loadStatus, product];
}
