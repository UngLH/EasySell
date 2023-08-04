part of 'shop_create_cubit.dart';

class ShopCreateState extends Equatable {
  final LoadStatus? loadStatus;
  final String? name;
  final String? address;
  final List<BankEntity>? listBanks;
  final String? accountName;

  const ShopCreateState(
      {this.loadStatus,
      this.name,
      this.address,
      this.listBanks,
      this.accountName});

  ShopCreateState copyWith(
      {LoadStatus? loadStatus,
      String? name,
      String? address,
      List<BankEntity>? listBanks,
      String? accountName}) {
    return ShopCreateState(
        loadStatus: loadStatus ?? this.loadStatus,
        name: name ?? this.name,
        address: address ?? this.address,
        listBanks: listBanks ?? this.listBanks,
        accountName: accountName ?? this.accountName);
  }

  @override
  List<Object?> get props =>
      [loadStatus, name, address, listBanks, accountName];
}
