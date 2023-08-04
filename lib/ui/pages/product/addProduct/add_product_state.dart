part of 'add_product_cubit.dart';

class AddProductState extends Equatable {
  final LoadStatus? loadStatus;
  final String? name;
  final String? address;

  const AddProductState({this.loadStatus, this.name, this.address});

  AddProductState copyWith({
    LoadStatus? loadStatus,
    String? name,
    String? address,
  }) {
    return AddProductState(
      loadStatus: loadStatus ?? this.loadStatus,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [loadStatus, name, address];
}
