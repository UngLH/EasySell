part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final LoadStatus? loadStatus;
  final String? email;
  final ShopEntity? shopEntity;

  const ProfileState({this.loadStatus, this.email, this.shopEntity});

  ProfileState copyWith({
    LoadStatus? loadStatus,
    String? email,
    ShopEntity? shopEntity,
  }) {
    return ProfileState(
        loadStatus: loadStatus ?? this.loadStatus,
        email: email ?? this.email,
        shopEntity: shopEntity ?? this.shopEntity);
  }

  @override
  List<Object?> get props => [loadStatus, email, shopEntity];
}
