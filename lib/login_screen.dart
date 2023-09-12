import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/forget_password_screen.dart';
import 'package:preggo/pregnancyInfo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameFieldController =
      TextEditingController();

  final TextEditingController _passwordFieldController =
      TextEditingController();

  final FocusNode _usernameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  bool hidePassword = true;
  bool isLoading = false;
  bool isUserValid = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> _loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } catch (error) {
      return null;
    }
  }

  Future<String> _fetchEmailFromFirestore() async {
    String email = "";

    if (_usernameFieldController.text.isNotEmpty &&
        _passwordFieldController.text.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userData = await firestore
          .collection("users")
          .where(
            "username",
            isEqualTo: _usernameFieldController.text.trim().toLowerCase(),
          )
          .where(
            "password",
            isEqualTo: _passwordFieldController.text.trim(),
          )
          .limit(1)
          .get();
      if (userData.docs.isNotEmpty) {
        email = userData.docs.first.data()['email'];
      }
    }
    return email;
  }

  Future<void> login() async {
    setState(() {
      isUserValid = true;
    });
    if (_formKey.currentState!.validate()) {
      final String userEmail = await _fetchEmailFromFirestore();
      if (userEmail.isNotEmpty) {
        final UserCredential? credential = await _loginWithEmailAndPassword(
          email: userEmail,
          password: _passwordFieldController.text,
        );

        if (credential?.user != null) {
          setState(() {
            isUserValid = true;
            if (mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pregnancyInfo(),
                  ));
            }
          });
        } else {
          setState(() {
            isUserValid = false;
          });
        }
      } else {
        setState(() {
          isUserValid = false;
        });
      }
    } else {
      setState(() {
        isUserValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: darkBlackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/preggo.png',
                  height: 180,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: _usernameFieldController,
                  focusNode: _usernameNode,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
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
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: textFieldBorderColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: darkGrayColor),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordFieldController,
                  focusNode: _passwordNode,
                  obscureText: hidePassword ? true : false,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
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
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: textFieldBorderColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty.';
                    }
                    return null;
                  },
                ),
                if (isUserValid == false) ...[
                  const SizedBox(height: 20.0),
                  Text(
                    "Incorrect username/password!",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen(),
                          ));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkGrayColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45.0),
                MaterialButton(
                  color: darkBlackColor,
                  minWidth: double.infinity,
                  height: 48,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: login,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: pinkColor,
                          ),
                        )
                      : const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                          ),
                        ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account yet? ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            return pregnancyInfo();
                          },
                        ), (route) => false);
                      },
                      child: Text(
                        'sign up now!',
                        // style: TextStyle(
                        //   fontSize: 15,
                        //   fontWeight: FontWeight.w700,
                        //   color: pinkColor,
                        // ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: pinkColor,
                            ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}