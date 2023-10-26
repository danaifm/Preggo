// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:intl/intl.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class postReply extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _postReply();
  }
}

class _postReply extends State<postReply>{

  String postId ='';

  var errorMessage = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _postReplyController = TextEditingController();

  String getTimestamp(){
    DateTime stamp = DateTime.now();
    String formattedStamp = DateFormat('yyyy/MM/dd hh:mm a').format(stamp);
    return formattedStamp;

  }


    ////////////////////////////////////////////
    Future<void> addNewReply(String post) async {
    
      final userUid = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String username = '';
      String userID = ''; 

    
      //ADD THE REPLY 
      if (userUid != null && _formKey.currentState!.validate()) {

        //GET USERNAME AND INCREMENT COMMENTS OF POST BY ONE 
        final DocumentReference postDocRef = firestore.collection('community').doc(post);
        final DocumentSnapshot postSnapshot = await postDocRef.get(); 
        if(postSnapshot.exists){
          final Map<String,dynamic> postData = postSnapshot.data() as Map<String,dynamic>;

          int comments = postData['comments'];
          comments++; 
          await postDocRef.update({'comments':comments});
        }

        //GET THE REPLIER'S USERNAME
        final DocumentReference userDocRef = firestore.collection('users').doc(userUid);
        final DocumentSnapshot userSnapshot = await userDocRef.get(); 
        if(userSnapshot.exists){
          final Map<String,dynamic> userData = userSnapshot.data() as Map<String,dynamic>;
          username= userData['username'];
          
        }

        //CREATE THE SUBCOLLECTION & ADD THE REPLY 
        CollectionReference repliesRef =
        firestore.collection('community').doc(post).collection('Replies');
        repliesRef.add({
          'username': username,
            'reply': _postReplyController.text,
            'timestamp': getTimestamp(),
        })
        .then((value){
          _successDialog();
          setState(() {
            _postReplyController.clear();
          });
        }) 
        
        .catchError((error) { 
          setState(() {
          errorMessage = "";
        });
        });
    }
        
      
  }

  Future<dynamic> _successDialog() {
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
                    color: Colors.white,
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
                            // color: pinkColor,
                            // border: Border.all(
                            //   width: 1.3,
                            //   color: Colors.black,
                            // ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Done
                        const Text(
                          "Reply added successfully!",
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
                              child: const Text("OK",
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                  )),
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
    ///////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    postId =ModalRoute.of(context)?.settings.arguments as String;
    var textStyleError = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 12.0,
      color: Theme.of(context).colorScheme.error,
      fontWeight: FontWeight.normal,
    );
    
    return Scaffold(
      

      body: Stack(
        children: [
          
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
            child: 
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                    const EdgeInsets.fromLTRB(5, 5, 0, 5),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      width:305,
                      child: TextFormField(
                        key: _nameKey,
                        maxLength: 250,
                        controller: _postReplyController,
                        
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Urbanist',
                          // color: pinkColor,
                        ),
                        decoration: InputDecoration(
                          
                          errorStyle: textStyleError,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)),
                            borderSide: BorderSide(
                                color: darkGrayColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: darkGrayColor),
                            // borderSide: BorderSide(color: darkGrayColor),
                          ),
                          hintText: "Write your Reply...",
                          filled: true,
                          fillColor: const Color(0xFFF7F8F9),
                        ),
                         //autovalidateMode:
                          //AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return "This field cannot be empty.";
                          }
                          return null;
                          
                        },
                      ),
                    ),
                  ),
                ),

              Transform.translate(
                offset: Offset(0,-12),
                child: Transform.rotate(
                  angle: 325*math.pi /180,
                  child: IconButton(
                    onPressed: () {
                      addNewReply(postId);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: darkBlackColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
              ],
            ),
              
            ),
          
          
          
        ],
      ),

    );
  }

}


/*
Center(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
              height:110,
              width: 350,
              decoration: BoxDecoration(
                color: backGroundPink.withOpacity(0.3),
                border: Border.all(color: backGroundPink, width: 2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: 
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                      size: 38,
                    ),
                    Text(
                    "$username ",
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 1.30,
                    letterSpacing: -0.28,
                    ),
                  ),
                  
                    ],
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        postTitle,
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w800,
                        height: 1.30,
                        letterSpacing: -0.28,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                        child: Text(
                          postBody,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                          height: 1.30,
                          letterSpacing: -0.28,
                          ),
                        ),
                      ),
                      SizedBox(height: 4,),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          getTimestamp(),
                          style: TextStyle(
                          color: Color.fromARGB(200, 121, 113, 113),
                          fontSize: 9,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w700,
                          height: 1.30,
                          letterSpacing: -0.28,
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

*/

