import 'package:flutter/material.dart';

import 'colors.dart';

Future<dynamic> showWrongPasswordDialog(BuildContext context) {
  return showDialog(
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
                          color: Colors.red,
                          //color: pinkColor,
                          // border: Border.all(
                          //   width: 1.3,
                          //   color: Colors.black,
                          // ),
                        ),
                        child: const Icon(
                          Icons.error,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Done
                      const Text(
                        "Password is Wrong!",
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

                      const SizedBox(height: 30),

                      /// OK Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.sizeOf(context).width * 0.80,
                        height: 45.0,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blackColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.only(
                                  left: 70, top: 15, right: 70, bottom: 15),
                            ),
                            child: const Text(
                              "OK",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
