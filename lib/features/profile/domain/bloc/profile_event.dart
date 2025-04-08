import 'package:equatable/equatable.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserModel user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserCategoriesEvent extends ProfileEvent {
  final List<String> categories;

  const UpdateUserCategoriesEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

class UpdateUserFashionStyleEvent extends ProfileEvent {
  final String? fashionStyle;

  const UpdateUserFashionStyleEvent(this.fashionStyle);

  @override
  List<Object?> get props => [fashionStyle];
}

class UpdateUserBrandsEvent extends ProfileEvent {
  final List<String> brands;

  const UpdateUserBrandsEvent(this.brands);

  @override
  List<Object?> get props => [brands];
}
