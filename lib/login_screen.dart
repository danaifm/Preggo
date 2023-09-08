import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameFieldController =
      TextEditingController();

  final TextEditingController _emailFieldController = TextEditingController();

  final TextEditingController _passwordFieldController =
      TextEditingController();

  final FocusNode _usernameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  bool hidePassword = true;
  bool isLoading = false;
  bool isUserdataValide = true;
  String validateUserMessage = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  // _loginWithEmailAndPassword() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   UserCredential user = await auth
  //       .signInWithEmailAndPassword(
  //           email: _emailFieldController.text,
  //           password: _passwordFieldController.text)
  //       .whenComplete(
  //     () {
  //       setState(() {
  //         isLoading = false;
  //       });

  //       /// Check if
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => LoginScreen(),
  //       //   ),
  //       // );
  //     },
  //   );
  // }

  Future<bool> _validateUsernameAndPassword() async {
    try {
      if (_usernameFieldController.text.isNotEmpty &&
          _passwordFieldController.text.isNotEmpty) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        final userData = await firestore
            .collection("users")
            .where(
              "username",
              isEqualTo: _usernameFieldController.text.trim(),
            )
            .where(
              "password",
              isEqualTo: _passwordFieldController.text.trim(),
            )
            .limit(1)
            .get();
        if (userData.docs.isEmpty) {
          isUserdataValide = false;
          // validateUserMessage = "";
        } else {
          isUserdataValide = true;
        }

        print("User data from firestore is:: ${userData.docs.length} #");
      } else {
        isUserdataValide = false;
      }
      if (mounted) setState(() {});
    } catch (error) {
      isUserdataValide = false;
      if (mounted) setState(() {});
    }
    return isUserdataValide;
  }

  _validateUserAndLogin() async {
    final isValideUser = await _validateUsernameAndPassword();
    if (_formKey.currentState!.validate()) {
      if (isValideUser) {
        if (mounted) {
          /// User valid
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const SplashScreen();
            },
          ));
        }
      }
      // _loginWithEmailAndPassword();
    } else {
      isUserdataValide = true;
      setState(() {});
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
                if (isUserdataValide == false) ...[
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
                    onTap: () {},
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
                  onPressed: _validateUserAndLogin,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: pinkColor,
                          ),
                        )
                      : const Text(
                          'Login',
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
                            return const SplashScreen();
                          },
                        ), (route) => false);
                      },
                      child: Text(
                        'register now!',
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
