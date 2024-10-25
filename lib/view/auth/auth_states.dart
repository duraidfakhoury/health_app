import 'package:flutter_health_app/model/FoodContent.dart';

abstract class AuthState {}

class AuthDartInitial extends AuthState {}

class RegisterSuccessState extends AuthState {}

class RegisterErrorState extends AuthState {
  final String error;
  RegisterErrorState(this.error);
}

class RegisterLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String error;
  LoginErrorState(this.error);
}

class LoginLoadingState extends AuthState {}

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<FoodContent> items;
  ItemsLoaded(this.items);
}

class ItemsError extends ItemsState {
  final String error;
  ItemsError(this.error);
}

class ItemsSuccess extends ItemsState {
  final String message;
  ItemsSuccess(this.message);
}
