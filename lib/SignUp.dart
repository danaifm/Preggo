//..
//new sign up

//SIGNUP.DART
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state, avoid_print, use_build_context_synchronously
//import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preggo/login_screen.dart';
import 'package:preggo/start_Journey.dart';
import 'package:string_validator/string_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:preggo/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'SplashScreen.dart';

class SignUp extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  PhoneController _phoneControllerCC = PhoneController(null);
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');
  bool usernameTaken = false;
  bool emailTaken = false;
  bool phoneTaken = false;
  bool hidePassword = true;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
//sign up UI

    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$'); //alphamumerical

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
/*
    PhoneNumberInputValidator? _getValidator() {
      List<PhoneNumberInputValidator> validators = [];
      validators.add(
        PhoneValidator.required(errorText: "This field cannot be empty."),
      );
      if (phoneTaken) {
        print('here');
        validators.add(
          PhoneValidator.valitd(errorText: "Phone number is already taken!"),
        );
      }
      validators.add(
        PhoneValidator.validMobile(),
      );
      return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
    }*/

    String phoneNo = '';
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backGroundPink,
        // backgroundColor: whiteColor,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                //const SizedBox(height: 40.0),
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "         Get Started",
                    style: TextStyle(
                      color: Color(0xFFD77D7C),
                      fontSize: 38,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      height: 1.30,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
                const SizedBox(height: 0.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 50,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 22.0,
                        right: 22,
                        top: 5.0,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(80.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 40.0),
                            Text("Create a Preggo account",
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 15.0),
                            /*const SizedBox(height: 40.0),
                            Text("Welcome back!",
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.w600,
                                )),
                                */
                            //  const SizedBox(height: 50.0),
                            Container(
                              height: 85,
                              constraints: BoxConstraints(maxHeight: 100),
                              child: TextFormField(
                                controller: _usernameController,
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

                                  if (value!.isEmpty == true) {
                                    return "This field cannot be empty.";
                                  } else if (!validCharacters.hasMatch(value)) {
                                    return "Only alphanumerical values allowed."; //maybe change error message
                                  } else if (usernameTaken) {
                                    return 'Username is already taken!';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Username",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: textFieldBorderColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: darkGrayColor),
                                  ),
                                ),
                              ),
                            ),

                            // const SizedBox(height: 22.0),
                            Container(
                              height: 85,
                              constraints: BoxConstraints(maxHeight: 100),
                              child: TextFormField(
                                controller: _emailController,
                                key: _emailKey,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field cannot be empty.";
                                  } else if (!EmailValidator.validate(value)) {
                                    return "Please enter a valid email.";
                                  } else if (emailTaken) {
                                    return 'Email is already taken!';
                                  } else {
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
                                  helperText: '',
                                  hintText: "Email",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: textFieldBorderColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: darkGrayColor),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              height: 85,
                              constraints: BoxConstraints(maxHeight: 100),
                              child: PhoneFormField(
                                countrySelectorNavigator:
                                    const CountrySelectorNavigator
                                        .searchDelegate(),
                                autovalidateMode: AutovalidateMode.disabled,
                                controller: _phoneControllerCC,
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
                                validator: PhoneValidator.validMobile(),
                                /* (phone) {
                                    bool hasLetter = false;
                                    int i = 0;
                                    while (i < phone!.toString().length) {
                                      if (!isNumeric(phone.toString().[i])) {
                                        hasLetter = true;
                                      }
                                      i++;
                                    }
                                    if (hasLetter) {
                                      return 'Field must contain only digits.';
                                    }
                                    if (phone.toString().isEmpty) {
                                      return 'This field cannot be empty.';
                                    } else if (phone.toString().length != 10) {
                                      return 'Phone number must be 10 digits.';
                                    } else if (phoneTaken) { !!!!!!!!!!!!!!!!!!!!!!!!!
                                      return 'Phone number is already taken!';
                                    } else {
                                      return null;
                                    }
                                  },*/
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  helperText: '',
                                  hintText: "Phone number (optional)",
                                  labelStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: grayColor,
                                  ),
                                  /*  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),*/
                                  filled: true,
                                  fillColor: textFieldBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: textFieldBorderColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: darkGrayColor),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              height: 85,
                              constraints: BoxConstraints(maxHeight: 90),
                              child: TextFormField(
                                controller: _passwordController,
                                /*
                                      password validations
                                      1- 8 digits or more
                                      2- at least one capital
                                      3- at least one number
                                      */

                                decoration: InputDecoration(
                                  helperText: '',
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Password',
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        BorderSide(color: textFieldBorderColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
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
                                  if (pass!.isEmpty == true) {
                                    return "This field cannot be empty.";
                                  } else if (pass.length < 8) {
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
                                      return "Password must contain at least one uppercase letter \nand one digit.";
                                    }
                                  } //end else
                                  return null;
                                },
                              ),
                            ),

                            //const SizedBox(height: 45.0),
                            MaterialButton(
                              color: darkBlackColor,
                              minWidth: double.infinity,
                              height: 48,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              onPressed: () async {
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
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);
                                  _formKey.currentState?.save();
                                  if (phoneNo.isEmpty) {
                                    Map<String, String> dataToSave = {
                                      'username': _usernameController.text
                                          .toLowerCase(),
                                      'email':
                                          _emailController.text.toLowerCase(),
                                      'admin': '0'
                                    };
                                    FirebaseFirestore.instance
                                        .collection('users/')
                                        .doc(userCredential.user!.uid)
                                        .set(dataToSave);
                                    print(
                                        'Registration successful with no phone');
                                  } else {
                                    Map<String, String> dataToSave = {
                                      'username': _usernameController.text
                                          .toLowerCase(),
                                      'email':
                                          _emailController.text.toLowerCase(),
                                      //'password': _passwordController.text,
                                      'phone': _phoneControllerCC.value!
                                          .getFormattedNsn(),
                                      'admin': '0'
                                    };
                                    FirebaseFirestore.instance
                                        .collection('users/')
                                        .doc(userCredential.user!.uid)
                                        .set(dataToSave);
                                    print('Registration successful with phone');
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplashScreen()));
                                }
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?  ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: blackColor,
                                      ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginScreen();
                                      },
                                    ), (route) => false);
                                  },
                                  child: Text(
                                    'Log In',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: pinkColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 100,
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
