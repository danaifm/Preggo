// ignore_for_file: must_be_immutable, library_prefixes, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as Cal;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:preggo/profile/cubit/profile_cubit.dart';
import 'package:string_validator/string_validator.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getUserData();
    ProfileCubit.get(context).getPregnancyInfoData();
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();
  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$'); //alphamumerical
  bool usernameTaken = false;
  bool emailTaken = false;
  bool hidePassword = true;
  late UserCredential userCredential;

  Future<bool> uniqueUsername(String username) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    return query.docs.isNotEmpty;
  }

  Future<bool> uniqueEmail(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get();
    return query.docs.isNotEmpty;
  }

  Future<bool> uniquePhone(String phone) async {
    print(phone);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();
    if (query.docs.isNotEmpty) {
      print("phone is taken");
    }
    return query.docs.isNotEmpty;
  }

  // bool hasSpecial(x) {
  //   RegExp _regExp = RegExp(r'^[0-9]');
  //   print(x.value);
  //   //print(x.value.nsn);
  //   if (!_regExp.hasMatch(x.value.nsn.toString())) {
  //     print("invalid");
  //     return true;
  //   }
  //   print('valid');
  //   return false;
  // }

  String phoneNo = '';

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      backgroundColor: backGroundPink,
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.w400)),
        backgroundColor: backGroundPink,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        /*    leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),*/
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateDataSuccess) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.40,
                      width: MediaQuery.sizeOf(context).width * 0.85,
                      child: Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: green,
                                    //color: pinkColor,
                                    // border: Border.all(
                                    //   width: 1.3,
                                    //   color: Colors.black,
                                    // ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Done
                                const Text(
                                  "Profile Edited successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                    letterSpacing: -0.28,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// OK Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.80,
                                  height: 45.0,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: blackColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        padding: const EdgeInsets.only(
                                            left: 70,
                                            top: 15,
                                            right: 70,
                                            bottom: 15),
                                      ),
                                      child: const Text(
                                        "OK",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          if (state is PasswordChangedSuccess) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.40,
                      width: MediaQuery.sizeOf(context).width * 0.85,
                      child: Dialog(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: green,
                                    //color: pinkColor,
                                    // border: Border.all(
                                    //   width: 1.3,
                                    //   color: Colors.black,
                                    // ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Done
                                const Text(
                                  "Appointment added successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                    letterSpacing: -0.28,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// OK Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.80,
                                  height: 45.0,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: blackColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        padding: const EdgeInsets.only(
                                            left: 70,
                                            top: 15,
                                            right: 70,
                                            bottom: 15),
                                      ),
                                      child: const Text(
                                        "OK",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
        builder: (context, state) {
          var user = ProfileCubit.get(context).userData;
          var babyData = ProfileCubit.get(context).pregnancyInfoModel;
          if (state is DataLoading || user == null || babyData == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorOccurred) {
            return const Center(child: Text("error"));
          }
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(80.0),
                        ),
                      ),
                      width: double.infinity,
                      child: const Text(""),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 50,
                      child: Text(
                        user.userName.split("")[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(80.0),
                        ),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 85,
                                constraints:
                                    const BoxConstraints(maxHeight: 100),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 25,
                                  controller: userNameController,
                                  key: _usernameKey,
                                  validator: (value) {
                                    /*
                                          username validations:
                                          --FRONT END--
                                          1- not empty
                                          2- no spaces
                                          3- no special characters (only letters and digits)
                                          --BACK END--
                                          4- unique
                                          */

                                    if (value!.isNotEmpty) {
                                      if (!validCharacters.hasMatch(value)) {
                                        return "Only alphanumerical values allowed."; //maybe change error message
                                      } else if (usernameTaken) {
                                        return 'Username is already taken!';
                                      }
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: user.userName,
                                    helperText: '',
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: grayColor,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: textFieldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: textFieldBorderColor),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: darkGrayColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 85,
                                constraints:
                                    const BoxConstraints(maxHeight: 100),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 50,
                                  controller: emailController,
                                  key: _emailKey,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (!EmailValidator.validate(value)) {
                                        return "Incorrect email format.";
                                        // var username =
                                        //     value.substring(0, value.indexOf('@'));
                                        // var domain = value.substring(
                                        //     value.indexOf('@') + 1,
                                        //     value.indexOf('.'));
                                        // var end =
                                        //     value.substring(value.indexOf('.') + 1);
                                        // bool specialChar = false;
                                        // for(int i = 0; i < username.length; i++){
                                        //   if(!isAlphanumeric(username[i])){
                                        //     if()
                                        //   }
                                        // }
                                      } else if (emailTaken) {
                                        return 'Email is already taken!';
                                        // } else if (EmailValidator.validate(value)) {
                                        //   var specialchar =
                                        //       RegExp(r'[!#$%^&*(),?":{}|<>/\+=-]');
                                        //   if (specialchar.hasMatch(value)) {
                                        //     return "Incorrect email format.";
                                        //   }
                                        //   var dot = '.'.allMatches(value).length;
                                        //   if (dot > 1) {
                                        //     return "Incorrect email format.";
                                        //   }
                                      } else {
                                        var specialchar = RegExp(
                                            r'[!#$%^&*(),?":{}|<>/\+=-]');
                                        if (specialchar.hasMatch(value)) {
                                          return "Incorrect email format.";
                                        }
                                        // var dot = '.'.allMatches(value).length;
                                        // if (dot > 1) {
                                        //   return "Incorrect email format.";
                                        // } //could be removed in the future if we can fix firebase invalid-email exception
                                        if (value
                                                .substring(
                                                    value.indexOf('.') + 1)
                                                .length <
                                            2) {
                                          return "Incorrect email format."; //for example abc@gmail.C (only 1 character after the dot) is invalid because firebase will throw invalid-email exception
                                        }
                                      }
                                      return null;
                                    }
                                  },
                                  /*
                                          email validations:
                                          --FRONT END--
                                          1- format: xxx@xxx.xxx
                                          2- only allowed characters of email
                                          3- only 1 @
                                          4- not empty
                                          --BACK END--
                                          5- unique
                                          */
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    helperText:
                                        'Email format should be: firstname@example.com',
                                    hintText: user.email,
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: grayColor,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: textFieldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: textFieldBorderColor),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: darkGrayColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 85,
                                constraints:
                                    const BoxConstraints(maxHeight: 100),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLength: 10,
                                  controller: phoneController,
                                  key: _phoneKey,
                                  onChanged: (p) => phoneNo = p.toString(),
                                  /*
                                          phone number validations
                                          --FRONT END--
                                          1- 10 digits
                                          2- digits only
                                          --BACK END--
                                          3- unique (???)
                                          */
                                  validator: (phone) {
                                    if (phone!.isNotEmpty) {
                                      bool hasLetter = false;
                                      int i = 0;
                                      while (i < phone.toString().length) {
                                        if (!isNumeric(phone.toString()[i])) {
                                          hasLetter = true;
                                        }
                                        i++;
                                      }
                                      if (hasLetter) {
                                        return 'Phone number must contain only digits.';
                                      } else if (phone.toString().length != 0 &&
                                          phone.toString().length != 10) {
                                        return 'Phone number must be 10 digits.';
                                        // } else if (phoneTaken) {
                                        //
                                        // return 'Phone number is already taken!';
                                      } else if (phone.toString().length ==
                                              10 &&
                                          phone.toString().substring(0, 2) !=
                                              '05') {
                                        return 'Incorrect phone number format.';
                                      } else {
                                        return null;
                                      }
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    helperText:
                                        'Phone number format should be: 05xxxxxxxx',
                                    hintText: user.phone,
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: grayColor,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: textFieldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: textFieldBorderColor),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: darkGrayColor),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // padding: EdgeInsets.only(bottom: 10),
                                height: 95,
                                constraints:
                                    const BoxConstraints(maxHeight: 95),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: oldPasswordController,
                                  maxLength: 50,

                                  /*
                                        password validations
                                        1- 8 digits or more
                                        2- at least one capital
                                        3- at least one number
                                        */

                                  decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    helperText:
                                        'Password should be at least 8 characters long',
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Current Password',
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: grayColor,
                                    ),
                                    filled: true,
                                    fillColor: textFieldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: textFieldBorderColor),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: darkGrayColor),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hidePassword = !hidePassword;
                                        });
                                      },
                                      child: hidePassword
                                          ? const Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            )
                                          : const Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),
                                  obscureText: hidePassword ? true : false,
                                  autocorrect: false,
                                  validator: (pass) {
                                    if (pass!.isNotEmpty) {
                                      print(pass);
                                      print(pass.trim().length);
                                      if (pass.trim().length < 8) {
                                        return "Password must be at least 8 characters.";
                                      } else {
                                        bool hasDigit = false;
                                        bool hasUppercase = false;
                                        int i = 0;
                                        while (i < pass.length) {
                                          if (isNumeric(pass[i])) {
                                            hasDigit = true;
                                          } else if (isUppercase(pass[i])) {
                                            hasUppercase = true;
                                          }
                                          i++;
                                        } //end while
                                        if (hasDigit == false ||
                                            hasUppercase == false) {
                                          return "Password must contain at least one uppercase \nletter and one digit.";
                                        }
                                      }
                                    } //and else
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                // padding: EdgeInsets.only(bottom: 10),
                                height: 95,
                                constraints:
                                    const BoxConstraints(maxHeight: 95),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: newPasswordController,
                                  maxLength: 50,

                                  /*
                                        password validations
                                        1- 8 digits or more
                                        2- at least one capital
                                        3- at least one number
                                        */

                                  decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    helperText:
                                        'Password should be at least 8 characters long',
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'New Password',
                                    labelStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: grayColor,
                                    ),
                                    filled: true,
                                    fillColor: textFieldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: textFieldBorderColor),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide:
                                          BorderSide(color: darkGrayColor),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hidePassword = !hidePassword;
                                        });
                                      },
                                      child: hidePassword
                                          ? const Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            )
                                          : const Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                    ),
                                  ),
                                  obscureText: hidePassword ? true : false,
                                  autocorrect: false,
                                  validator: (pass) {
                                    if (pass!.isNotEmpty) {
                                      print(pass);
                                      print(pass.trim().length);
                                      if (pass.trim().length < 8) {
                                        return "Password must be at least 8 characters.";
                                      } else {
                                        bool hasDigit = false;
                                        bool hasUppercase = false;
                                        int i = 0;
                                        while (i < pass.length) {
                                          if (isNumeric(pass[i])) {
                                            hasDigit = true;
                                          } else if (isUppercase(pass[i])) {
                                            hasUppercase = true;
                                          }
                                          i++;
                                        } //end while
                                        if (hasDigit == false ||
                                            hasUppercase == false) {
                                          return "Password must contain at least one uppercase \nletter and one digit.";
                                        }
                                      }
                                    } //and else
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              MaterialButton(
                                color: darkBlackColor,
                                minWidth: double.infinity,
                                height: 48,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: () async {
                                  final FormState form = _formKey.currentState!;
                                  form.validate();
                                  usernameTaken = await uniqueUsername(
                                      _usernameKey.currentState!.value);
                                  setState(() {});
                                  emailTaken = await uniqueEmail(
                                      _emailKey.currentState!.value);
                                  /*setState(() {});
                                  phoneTaken = await uniquePhone(
                                      _phoneKey.currentState?.value);*/
                                  setState(() {});
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    await ProfileCubit.get(context)
                                        .updateUserData(
                                            userName:
                                                userNameController.text.trim(),
                                            email: emailController.text.trim(),
                                            phone: phoneController.text.trim());
                                    if (mounted) {
                                      await ProfileCubit.get(context)
                                          .changePassword(
                                              oldPasswordController.text.trim(),
                                              newPasswordController.text.trim(),
                                              context);
                                    }
                                  }
                                },
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
