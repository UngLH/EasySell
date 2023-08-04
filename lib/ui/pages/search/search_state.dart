part of 'search_cubit.dart';

class SearchState extends Equatable {
  final LoadStatus? loadStatus;
  final ProductEntity? product;
  final String? barcode;
  final bool? showModal;

  const SearchState(
      {this.loadStatus, this.product, this.barcode, this.showModal});

  SearchState copyWith(
      {LoadStatus? loadStatus,
      ProductEntity? product,
      String? barcode,
      bool? showModal}) {
    return SearchState(
        loadStatus: loadStatus ?? this.loadStatus,
        product: product ?? this.product,
        barcode: barcode ?? this.barcode,
        showModal: showModal ?? this.showModal);
  }

  @override
  List<Object?> get props => [loadStatus, product, barcode, showModal];
}
