//SIGNUP.DART
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preggo/login_screen.dart';
import 'package:string_validator/string_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:preggo/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SplashScreen.dart';
//import 'homeScreen.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();
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
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();
      return query.docs.isNotEmpty;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 70),
          padding: const EdgeInsets.symmetric(horizontal: 22.0), //from aliyah
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get Started",
                style: TextStyle(
                  color: Color(0xFFD77D7C),
                  fontSize: 38,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w700,
                  height: 1.30,
                  letterSpacing: -0.28,
                ),
              ),
              Text(
                " by creating a Preggo account.",
                style: TextStyle(
                  color: Color(0xFF252525),
                  fontSize: 18,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            hintText: "Enter your username",
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
                              borderSide: BorderSide(color: darkGrayColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                            hintText: "Enter your email",
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
                              borderSide: BorderSide(color: darkGrayColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _phoneController,
                          key: _phoneKey,
                          /*
                                phone number validations
                                --FRONT END--
                                1- 10 digits
                                2- digits only
                                --BACK END--
                                3- unique (???)
                                */
                          validator: (phone) {
                            bool hasLetter = false;
                            int i = 0;
                            while (i < phone!.length) {
                              if (!isNumeric(phone[i])) {
                                hasLetter = true;
                              }
                              i++;
                            }
                            if (hasLetter) {
                              return 'Field must contain only digits.';
                            }
                            if (phone.isEmpty) {
                              return 'This field cannot be empty.';
                            } else if (phone.length != 10) {
                              return 'Phone number must be 10 digits.';
                            } else if (phoneTaken) {
                              return 'Phone number is already taken!';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter your phone number",
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: textFieldBorderColor),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide: BorderSide(color: darkGrayColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _passwordController,
                          /*
                                password validations
                                1- 8 digits or more
                                2- at least one capital
                                3- at least one number
                                */
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            hintText: 'Enter your password',
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
                              borderSide: BorderSide(color: darkGrayColor),
                              // borderSide: BorderSide(color: darkGrayColor),
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
                              if (hasDigit == false || hasUppercase == false) {
                                return "Password must contain at least one uppercase letter \nand one digit.";
                              }
                            } //end else
                            return null;
                          },
                        ),
                      ),
                      // Padding(
                      //padding: const EdgeInsets.only(top: 10.0),
                      // child:
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: SizedBox(
                          height: 45.0,
                          child: MaterialButton(
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
                              setState(() {});
                              phoneTaken = await uniquePhone(
                                  _phoneKey.currentState!.value);
                              setState(() {});
                              if (_formKey.currentState!.validate()) {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text);
                                _formKey.currentState?.save();
                                Map<String, String> dataToSave = {
                                  'username':
                                      _usernameController.text.toLowerCase(),
                                  'email': _emailController.text.toLowerCase(),
                                  'password': _passwordController.text,
                                  'phone': _phoneController.text,
                                  'admin': '0'
                                };
                                FirebaseFirestore.instance
                                    .collection('users/')
                                    .doc(userCredential.user!.uid)
                                    .set(dataToSave);
                                print('Registration successful');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()));
                              }
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                              // style: TextStyle(
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.w700,
                              //   color: pinkColor,
                              // ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: pinkColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /* Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 15,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                        height: 1.40,
                        letterSpacing: 0.15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Color(0xFFD77D7C),
                          fontSize: 15,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
