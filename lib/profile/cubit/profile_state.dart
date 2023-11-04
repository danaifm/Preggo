part of 'profile_cubit.dart';

@immutable
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class UserDataSuccess extends ProfileState {}

class PasswordChangedSuccess extends ProfileState {}

class WrongPassword extends ProfileState {
  final String issuedTime;

  WrongPassword() : issuedTime = DateTime.now().toString();

  @override
  List<Object?> get props => [issuedTime];
}

class UpdateDataSuccess extends ProfileState {}

class DataLoading extends ProfileState {}

class DeleteUserSuccess extends ProfileState {}

class ErrorOccurred extends ProfileState {
  final String error;

  ErrorOccurred({required this.error});

  @override
  List<Object?> get props => [error];
}
