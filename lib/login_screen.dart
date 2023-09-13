import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/colors.dart';
//import 'package:preggo/forget_password_screen.dart';

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
      isLoading = true;
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
                    builder: (context) => const SplashScreen(),
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
    setState(() {
      isLoading = false;
    });
    print("isUserValid:: $isUserValid #");
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      backgroundColor: backGroundPink,
      // backgroundColor: whiteColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 5.0),
              Image.asset(
                'assets/images/preggo.png',
                height: 180,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 5.0,
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
                        Text("Welcome back!",
                            style: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 45.0),
                        Container(
                          height: 90,
                          constraints: BoxConstraints(maxHeight: 100),
                          child: TextFormField(
                            controller: _usernameFieldController,
                            focusNode: _usernameNode,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "Username",
                              errorStyle: textStyle,
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field cannot be empty.';
                              }
                              return null;
                            },
                          ),
                        ),
                        // const SizedBox(height: 22.0),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              height: 90,
                              constraints: BoxConstraints(maxHeight: 100),
                              child: TextFormField(
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
                                  errorStyle: textStyle,
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
                            ),
                            Positioned(
                              bottom: 5,
                              child: Container(
                                height: 12,
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: isUserValid
                                      ? const SizedBox()
                                      : Text(
                                          "Incorrect username/password!",
                                          style: textStyle,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashScreen(),
                                    // ForgetPasswordScreen(),
                                  ));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: pinkColor,
                                decoration: TextDecoration.underline,
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
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account yet? ',
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
                                    return const SplashScreen();
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
