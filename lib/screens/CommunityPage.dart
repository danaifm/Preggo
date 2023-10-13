// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import '../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  _CommunityPage createState() => _CommunityPage();
}

int _tabTextIndexSelected = 0;
List<String> _listTextTabToggle = ['All Posts', 'My Posts'];
late Future<QuerySnapshot<Map<String, dynamic>>> _allPosts;

Future<QuerySnapshot<Map<String, dynamic>>> getAllPosts() async {
  var result = FirebaseFirestore.instance.collection('community').get();
  return result;
}

class _CommunityPage extends State<CommunityPage> {
  @override
  void initState() {
    _allPosts = getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 45),

            // child: RichText(
            //   text: const TextSpan(
            //     style: TextStyle(
            //       fontFamily: 'Urbanist',
            //     ),
            //     children:
            //      <TextSpan>[
            //       TextSpan(
            //           text: 'Community\n',
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 35,
            //               fontWeight: FontWeight.w400)),
            //       TextSpan(
            //           text: ' Welcome to the Preggo Community!',
            //           style:
            //               TextStyle(color: Color.fromARGB(255, 121, 119, 119))),
            //     ],
            //   ),
            // ),
          ),
          FlutterToggleTab(
            width: 60, // width in percent
            borderRadius: 30,
            height: 50,
            selectedIndex: _tabTextIndexSelected,
            selectedBackgroundColors: [pinkColor, pinkColor],
            selectedTextStyle: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            unSelectedTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            labels: _listTextTabToggle,
            selectedLabelIndex: (index) {
              setState(() {
                _tabTextIndexSelected = index;
                print(_tabTextIndexSelected);
              });
            },
            isScroll: false,
          ),
          communityWidget(_tabTextIndexSelected),
        ], //column children
      ),
    );
  }
}

Widget communityWidget(_tabTextIndexSelected) {
  if (_tabTextIndexSelected == 0) //All posts
  {
    return allPosts();
  } else //My posts
  {
    return myPosts();
  }
}

Widget allPosts() {
  return Container(
    child: FutureBuilder(
        future: _allPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            //there are posts
            List allPosts = snapshot.data!.docs; //TODO: SORT BY LATEST
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                height: 505,
                child: ListView.builder(
                  itemCount: allPosts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text('hi');
                  },
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            //there are no posts
            return Center(child: Text('no posts'));
          } else {
            return Center(child: CircularProgressIndicator()); //still loading
          }
        }),
  );
}

Widget myPosts() {
  return Container();
}
