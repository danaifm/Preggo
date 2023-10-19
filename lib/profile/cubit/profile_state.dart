part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class UserDataSuccess extends ProfileState {}
class PasswordChangedSuccess extends ProfileState {}
class UpdateDataSuccess extends ProfileState {}
class DataLoading extends ProfileState {}
class DeleteUserSuccess extends ProfileState {}
class ErrorOccurred extends ProfileState {
  final String error;

  ErrorOccurred({required this.error});
}
