part of 'home_cubit.dart';

class HomeState extends Equatable {
  final LoadStatus? loadStatus;
  final String? name;
  final String? address;
  final List<ProductEntity>? products;

  const HomeState({this.loadStatus, this.name, this.address, this.products});

  HomeState copyWith(
      {LoadStatus? loadStatus,
      String? name,
      String? address,
      List<ProductEntity>? products}) {
    return HomeState(
        loadStatus: loadStatus ?? this.loadStatus,
        name: name ?? this.name,
        address: address ?? this.address,
        products: products ?? this.products);
  }

  @override
  List<Object?> get props => [loadStatus, name, address, products];
}
