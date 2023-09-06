//SIGNUP.DART
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:email_validator/email_validator.dart';

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
  bool _passwordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
//sign up UI

    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$'); //alphamumerical

    Future<bool> uniqueUsername(String username) async {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return query.docs.isNotEmpty;
    }

    Future<bool> uniqueEmail(String email) async {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
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
          margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
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
                              return "Field cannot be empty.";
                            } else if (!validCharacters.hasMatch(value)) {
                              return "Only alphanumerical values allowed."; //maybe change error message
                            } else if (usernameTaken) {
                              return 'Username is already taken!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // gapPadding: 100,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            hintText: "Enter your Username",
                            filled: true,
                            fillColor: Color(0xFFF7F8F9),
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
                              return "Field cannot be empty.";
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // gapPadding: 100,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            hintText: "Enter your Email",
                            filled: true,
                            fillColor: Color(0xFFF7F8F9),
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
                              return 'Field cannot be empty.';
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            hintText: "Enter your Phone Number",
                            filled: true,
                            fillColor: Color(0xFFF7F8F9),
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(
                                  () {
                                    _passwordVisible = !_passwordVisible;
                                  },
                                );
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15),
                            focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromRGBO(255, 100, 100, 1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              gapPadding: 0.5,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // gapPadding: 100,
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                width: 0.50,
                                color: Color.fromARGB(255, 221, 225, 232),
                              ),
                            ),
                            hintText: "Enter your Password",
                            filled: true,
                            fillColor: Color(0xFFF7F8F9),
                          ),
                          obscureText: !_passwordVisible,
                          autocorrect: false,
                          validator: (pass) {
                            if (pass!.isEmpty == true) {
                              return "Field cannot be empty.";
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
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
                              _formKey.currentState?.save();
                              Map<String, String> dataToSave = {
                                'username': _usernameController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'phone': _phoneController.text,
                                'admin': '0'
                              };
                              FirebaseFirestore.instance
                                  .collection('users/')
                                  .doc(_usernameController.text)
                                  .set(dataToSave);
                              print('Registration successful');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 132, vertical: 15),
                          ),
                          child: Text("Register"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
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
                          MaterialPageRoute(builder: (context) => SignUp()),
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
            ],
          ),
        ),
      ),
    );
  }
}
