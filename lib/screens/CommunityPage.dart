// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import '../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  @override
  _CommunityPage createState() => _CommunityPage();
}

int _tabTextIndexSelected = 0;
List<String> _listTextTabToggle = ['All Posts', 'My Posts'];
late Future<QuerySnapshot<Map<String, dynamic>>> _allPosts;
late Future<QuerySnapshot<Map<String, dynamic>>> _myPosts;

Future<QuerySnapshot<Map<String, dynamic>>> getAllPosts() async {
  var result = FirebaseFirestore.instance.collection('community').get();
  return result;
}

Future<QuerySnapshot<Map<String, dynamic>>> getMyPosts() async {
  User? user = FirebaseAuth.instance.currentUser;
  String uid = user!.uid;
  print(uid);
  var result = FirebaseFirestore.instance
      .collection('community')
      .where('userID', isEqualTo: uid)
      .get();
  return result;
}

class _CommunityPage extends State<CommunityPage> {
  @override
  void initState() {
    _allPosts = getAllPosts();
    _myPosts = getMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          communityWidget(_tabTextIndexSelected),
          Container(
            padding: EdgeInsets.only(top: 50, left: 65),
            child: FlutterToggleTab(
              width: 60, // width in percent
              borderRadius: 30,
              height: 50,
              selectedIndex: _tabTextIndexSelected,
              selectedBackgroundColors: [pinkColor, pinkColor],
              selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
              unSelectedTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              labels: _listTextTabToggle,
              selectedLabelIndex: (index) {
                setState(
                  () {
                    _tabTextIndexSelected = index;
                    print(_tabTextIndexSelected);
                  },
                );
              },
              isScroll: false,
            ),
          ),
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
    // return Center(child: Text('hi'));
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
              height: 800,
              child: ListView.builder(
                itemCount: allPosts.length + 2,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 70,
                    );
                  } else if (index > 0 && index < allPosts.length + 1) {
                    String username = allPosts[index - 1].data()['username'];
                    String postTitle = allPosts[index - 1].data()['title'];
                    String postBody = allPosts[index - 1].data()['body'];
                    String stamp = allPosts[index - 1].data()['timestamp'];
                    return GestureDetector(
                      onTap: () {
                        print('tapped');
                      }, //TODO: rana's page
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        height: 110,
                        width: 350,
                        decoration: BoxDecoration(
                          color: backGroundPink.withOpacity(0.3),
                          border: Border.all(color: backGroundPink, width: 2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.black,
                                  size: 38,
                                ),
                                Text(
                                  username,
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
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      stamp,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(200, 121, 113, 113),
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
                    );
                  } else {
                    return Container(height: 110);
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          //TODO: there are no posts
          return Center(child: Text('no posts'));
        } else {
          return Center(
              child: CircularProgressIndicator()); //TODO: still loading
        }
      },
    ),
  );
}

Widget myPosts() {
  print('my posts');
  return Container(
    child: FutureBuilder(
      future: _myPosts,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          //there are posts
          List myPosts = snapshot.data!.docs; //TODO: SORT BY LATEST
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Container(
              height: 800,
              child: ListView.builder(
                itemCount: myPosts.length + 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    print('index 0');
                    return Container(height: 70);
                  } else if (index > 0 && index < myPosts.length + 1) {
                    print('at least 1 in my posts');
                    String username = myPosts[index - 1].data()['username'];
                    String postTitle = myPosts[index - 1].data()['title'];
                    String postBody = myPosts[index - 1].data()['body'];
                    String stamp = myPosts[index - 1].data()['timestamp'];
                    return GestureDetector(
                      onTap: () {}, //TODO: rana's page
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        height: 110,
                        width: 350,
                        decoration: BoxDecoration(
                          color: backGroundPink.withOpacity(0.3),
                          border: Border.all(color: backGroundPink, width: 2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.black,
                                  size: 38,
                                ),
                                Text(
                                  username,
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
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      stamp,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(200, 121, 113, 113),
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
                    );
                  } else {
                    return Container(height: 110);
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          //TODO: there are no posts
          print('no my posts');
          return Center(child: Text('none in my posts'));
        } else {
          return Center(
              child: CircularProgressIndicator()); //TODO: still loading
        }
      },
    ),
  );
}

String getTimestamp(DateTime stamp) {
  String formattedStamp = DateFormat('yyyy/MM/dd hh:mm a').format(stamp);
  return formattedStamp;
}
