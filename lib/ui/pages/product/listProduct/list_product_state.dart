part of 'list_product_cubit.dart';

class ListProductState extends Equatable {
  final LoadStatus? loadStatus;
  List<ProductEntity>? listProduct = [];

  ListProductState({this.loadStatus, this.listProduct});

  ListProductState copyWith(
      {LoadStatus? loadStatus, List<ProductEntity>? listProduct}) {
    return ListProductState(
        loadStatus: loadStatus ?? this.loadStatus,
        listProduct: listProduct ?? this.listProduct);
  }

  @override
  List<Object?> get props => [loadStatus, listProduct];
}
