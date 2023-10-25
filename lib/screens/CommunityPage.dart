// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import '../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'post_community.dart';

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
    int count = 0;
    refreshData() {
      count++;
      print(count);
    }

    onGoBack(dynamic value) {
      refreshData();
      setState(() {});
    }

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
            //     children: <TextSpan>[
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 20, 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => PostCommunityScreen()),
                        maintainState: false,
                      )).then(onGoBack);
                  //TODO: ALIYAH'S PAGE THEN REFRESH
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(55, 55),
                  shape: const CircleBorder(),
                  backgroundColor: darkBlackColor,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
  }
}

Widget allPosts() {
  return Container(
    child: FutureBuilder(
      future: _allPosts,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          //there are posts
          List allPosts = snapshot.data!.docs;
          allPosts.sort((a, b) {
            //SORT BY LATEST
            // Convert 'timestamp' strings to DateTime objects for comparison
            DateFormat tF = DateFormat("hh:mm a");
            DateFormat dF = DateFormat("yyyy-MM-dd");

            DateTime timeA =
                tF.parse(a.data()['timestamp'].toString().substring(11));
            DateTime timeB =
                tF.parse(b.data()['timestamp'].toString().substring(11));

            DateTime dateA = dF.parse(a
                .data()['timestamp']
                .toString()
                .substring(0, 10)
                .replaceAll('/', '-'));
            DateTime dateB = dF.parse(b
                .data()['timestamp']
                .toString()
                .substring(0, 10)
                .replaceAll('/', '-'));

            if (dateA.compareTo(dateB) != 0) {
              return dateB.compareTo(dateA);
            } else {
              return timeB.compareTo(timeA);
            }
          });

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 800,
              child: ListView.builder(
                itemCount: allPosts.length + 2,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(height: 70);
                  } else if (index > 0 && index < allPosts.length + 1) {
                    String username = allPosts[index - 1].data()['username'];
                    String postTitle = allPosts[index - 1].data()['title'];
                    String postBody = allPosts[index - 1].data()['body'];
                    String stamp = allPosts[index - 1].data()['timestamp'];
                    String postID =
                        snapshot.data!.docs[index - 1].reference.id.toString();
                    String commentsNum =
                        allPosts[index - 1].data()['comments'].toString() ==
                                'null'
                            ? '0'
                            : allPosts[index - 1].data()['comments'].toString();
                    // String commentsNum = snapshot.data!.docs[index - 1];
                    return GestureDetector(
                      onTap: () {
                        print(postID);
                        //  Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => (RANAS PAGE)
                        //         settings: RouteSettings(arguments: postID),
                        //       ),).then(onGoBack);
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                              width: 25,
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 10,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            stamp,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 121, 113, 113),
                                              fontSize: 9,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              height: 1.30,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 90),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 1.0),
                                              child: Icon(
                                                Icons.chat_bubble_outline,
                                                color: Color.fromARGB(
                                                    200, 121, 113, 113),
                                                size: 15,
                                              ),
                                            ),
                                            Text(
                                              commentsNum,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    200, 121, 113, 113),
                                                fontSize: 12,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w700,
                                                height: 1.30,
                                                letterSpacing: -0.28,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
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
          return Center(
            child: Text(
              'No Posts Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.28,
              ),
            ),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: pinkColor,
          ));
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
          List myPosts = snapshot.data!.docs;
          myPosts.sort((a, b) {
            //SORT BY LATEST
            // Convert 'timestamp' strings to DateTime objects for comparison
            DateFormat tF = DateFormat("hh:mm a");
            DateFormat dF = DateFormat("yyyy-MM-dd");

            DateTime timeA =
                tF.parse(a.data()['timestamp'].toString().substring(11));
            DateTime timeB =
                tF.parse(b.data()['timestamp'].toString().substring(11));

            DateTime dateA = dF.parse(a
                .data()['timestamp']
                .toString()
                .substring(0, 10)
                .replaceAll('/', '-'));
            DateTime dateB = dF.parse(b
                .data()['timestamp']
                .toString()
                .substring(0, 10)
                .replaceAll('/', '-'));

            if (dateA.compareTo(dateB) != 0) {
              return dateB.compareTo(dateA);
            } else {
              return timeB.compareTo(timeA);
            }
          });
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: SizedBox(
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
                    String postID =
                        snapshot.data!.docs[index - 1].reference.id.toString();
                    String commentsNum =
                        myPosts[index - 1].data()['comments'].toString() ==
                                'null'
                            ? '0'
                            : myPosts[index - 1].data()['comments'].toString();

                    return GestureDetector(
                      onTap: () {
                        print(postID);
                        //  Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => (RANAS PAGE)
                        //         settings: RouteSettings(arguments: postID),
                        //       ),).then(onGoBack);
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                              width: 25,
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 10,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            stamp,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  200, 121, 113, 113),
                                              fontSize: 9,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w700,
                                              height: 1.30,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 90),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 1.0),
                                              child: Icon(
                                                Icons.chat_bubble_outline,
                                                color: Color.fromARGB(
                                                    200, 121, 113, 113),
                                                size: 15,
                                              ),
                                            ),
                                            Text(
                                              commentsNum,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    200, 121, 113, 113),
                                                fontSize: 12,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w700,
                                                height: 1.30,
                                                letterSpacing: -0.28,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
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
          return Center(
            child: Text(
              'No Posts Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.28,
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(color: pinkColor));
        }
      },
    ),
  );
}
