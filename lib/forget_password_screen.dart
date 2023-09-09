import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController _usernameFieldController =
      TextEditingController();

  final FocusNode _usernameNode = FocusNode();

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
          .sendPasswordResetEmail(email: _usernameFieldController.text)
          .then((value) {
        setState(() {
          isLoading = true;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
        // Fluttertoast.showToast(
        //     msg: "We have sent you an e-mail to reset your password",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor:Colors.white,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,),onPressed: () => Navigator.pop(context),),),
        
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  Container(
                    alignment: AlignmentDirectional.center,
                    child: Image.asset(
                      'assets/images/preggo.png',
                      height: 180,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: darkBlackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    ' A link will be send to your email to reset it',
                    style: TextStyle(
                      color: darkBlackColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameFieldController,
                    focusNode: _usernameNode,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
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
                      if (!value.contains("@") || !value.contains(".com")) {
                        return 'Email is not valid.';
                      }
                      return null;
                    },
                  ),
                  if (isError) ...[
                    const SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        "Email doesn't exist",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
