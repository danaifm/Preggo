import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/login_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailFieldController = TextEditingController();

  final FocusNode _emailNode = FocusNode();

  bool isLoading = false;

  bool isError = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  sendEmail() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        isError = false;
      });

      auth
          .sendPasswordResetEmail(email: _emailFieldController.text.trim())
          .then((value) async {
        setState(() {
          isLoading = true;
        });
        Fluttertoast.showToast(
            msg: "We have sent you an e-mail to reset your password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }).catchError((error) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundPink,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
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
                    vertical: 50.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(80.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: darkBlackColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'A link will be send to your email to reset your password.',
                          style: TextStyle(
                            color: darkBlackColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 35.0),
                        Stack(
                          children: [
                            Container(
                              height: 90,
                              constraints: const BoxConstraints(maxHeight: 100),
                              child: TextFormField(
                                maxLength: 50,
                                controller: _emailFieldController,
                                focusNode: _emailNode,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  labelStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: grayColor,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cannot be empty.';
                                  }
                                  if (!value.contains("@") ||
                                      !value.contains(".")) {
                                    return 'Incorrect email format.';
                                  }
                                  if (value.length < 8) {
                                    return 'Email is not valid.';
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
                                  child: !isError
                                      ? const SizedBox()
                                      : Text(
                                          "Email doesn't exist",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 12.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        MaterialButton(
                          color: darkBlackColor,
                          minWidth: double.infinity,
                          height: 48,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          onPressed: sendEmail,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: pinkColor,
                                  ),
                                )
                              : const Text(
                                  'Reset password',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: whiteColor,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20.0),
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
