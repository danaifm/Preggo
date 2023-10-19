import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:preggo/model/pregnancy_model.dart';

import '../../model/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? userData;

  Future getUserData() async {
    print("+++++++++++++++++++++++++${FirebaseAuth.instance.currentUser!.uid}");
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      log('+++++++++++++++++++++++++++++');
      log(response.toString());
      userData = UserModel.fromJson(response.data()!);
      log(response.toString());
      log('+++++++++++++++++++++++++++++');
      emit(UserDataSuccess());
    } on Exception catch (e) {
      print(e.toString());
      emit(ErrorOccurred(error: e.toString()));
    }
  }

  Future<void> changePassword(String currentPassword,String newPassword, BuildContext context) async {
    try {
      if (newPassword.isEmpty) return;
      // Get the current user object from Firebase Authentication.
      final user = FirebaseAuth.instance.currentUser;

      // If the user is not signed in, return.
      if (user == null) {
        return;
      }

      // Create a credential object with the user's current password.
      final credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);

      // Reauthenticate the user with their current password.
      await user.reauthenticateWithCredential(credential);

      // Update the user's password with the new password.
      await user.updatePassword(newPassword);
      emit(PasswordChangedSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("wrong password")));
      }
      print(e.toString());
    }
  }

  Future updateUserData({
    required String userName,
    required String email,
    required String phone,
  }) async {
    print("+++++++++++++++++++++++++${FirebaseAuth.instance.currentUser!.uid}");
    try {
      if (userName.isEmpty && email.isEmpty && phone.isEmpty) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        if (userName.isNotEmpty) "username": userName,
        if (email.isNotEmpty) "email": email,
        if (phone.isNotEmpty) "phone": phone,
      });

      log('+++++++++++++++++++++++++++++');
      emit(UpdateDataSuccess());
    } on Exception catch (e) {
      print(e.toString());
      emit(ErrorOccurred(error: e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    // Get the user's document reference from the `users` collection.
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Delete the user's document from the `users` collection.
    await userDocRef.delete();

    // Delete the user's account from Firebase Authentication.
    await FirebaseAuth.instance.currentUser!.delete();
    emit(DeleteUserSuccess());
    // Return a success message.
  }

  List<PregnancyInfoModel>? pregnancyInfoModel;

  Future getPregnancyInfoData() async {
    if (pregnancyInfoModel != null) return;
    print("+++++++++++++++++++++++++${FirebaseAuth.instance.currentUser!.uid}");
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("pregnancyInfo")
          .get();
      log('+++++++++++++++++++++++++++++');
      log(response.toString());
      for (var element in response.docs) {
        log(element.data().toString());
        pregnancyInfoModel ??= [];
        pregnancyInfoModel!.add(PregnancyInfoModel.fromJson(element.data()));
      }

      log(response.toString());
      log('+++++++++++++++++++++++++++++');
      emit(UserDataSuccess());
    } on Exception catch (e) {
      print(e.toString());
      emit(ErrorOccurred(error: e.toString()));
      throw e;
    }
  }
}
