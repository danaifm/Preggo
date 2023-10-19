// ignore_for_file: must_be_immutable, library_prefixes, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as Cal;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:preggo/profile/cubit/profile_cubit.dart';
import 'package:preggo/profile/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    ProfileCubit.get(context).getUserData();
    ProfileCubit.get(context).getPregnancyInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundPink,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var user = ProfileCubit.get(context).userData;
          var babyData = ProfileCubit.get(context).pregnancyInfoModel;
          if (state is DataLoading || user == null || babyData == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorOccurred) {
            return const Text("error");
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // InkWell(
                    // onTap: ()=> Navigator.pop(context),
                    //  child: Image.asset("assets/images/arrow-left.png")),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                child: const Center(
                                    child: Text("Profile",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 35,
                                            fontWeight: FontWeight.w400))))),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(80.0),
                      ),
                    ),
                    width: double.infinity,
                    child: const Text(""),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 50,
                    child: Text(
                      user.userName.split("")[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(80.0),
                      ),
                    ),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: blackColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            EditProfileScreen())).then(
                                    (value) => ProfileCubit.get(context)
                                        .getUserData());
                              },
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Center(
                                child: Text(
                              "Account information",
                              style: TextStyle(
                                  color: pinkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.person_outline_outlined,
                                      color: grayColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      user.userName,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.email_outlined,
                                      color: grayColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      user.email,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.phone_outlined,
                                      color: grayColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      user.phone.isEmpty ? "" : user.phone,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Center(
                                child: Text(
                              "Pregnancy history",
                              style: TextStyle(
                                  color: pinkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              physics: babyData.length > 1
                                  ? AlwaysScrollableScrollPhysics()
                                  : NeverScrollableScrollPhysics(),
                              itemCount: babyData.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/person.png',
                                      height: 25,
                                      width: 25,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      babyData[index].babyName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.navigate_next_sharp),
                                  ],
                                ),
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(
                                height: 5,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Center(
                                child: Text(
                              "Sign Out",
                              style: TextStyle(
                                  color: pinkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // <-- SEE HERE

                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              'Are you sure you want to \nSign Out ?',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 25,
                                                  right: 25),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onTap: () => Navigator.pop(context),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "Sign Out",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onTap: () async {
                                              const _scopes = const [
                                                Cal.CalendarApi.calendarScope
                                              ]; //scope to CREATE EVENT in calendar
                                              GoogleSignIn _googleSignIn =
                                                  GoogleSignIn(
                                                // Optional clientId
                                                // clientId: 'your-client_id.apps.googleusercontent.com',
                                                scopes: _scopes,
                                              );

                                              _googleSignIn.disconnect();

                                              //disconnect the authorized google account on logging out
                                              await auth.signOut();
                                              await AwesomeNotifications()
                                                  .cancelAll();
                                              if (context.mounted) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Sign Out",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: const Center(
                                child: Text(
                              "Delete Account",
                              style: TextStyle(
                                  color: pinkColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // <-- SEE HERE

                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              'Are you sure you want to \nDelete Your Account?',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 25,
                                                  right: 25),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onTap: () => Navigator.pop(context),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20,
                                                  right: 20),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onTap: () async {
                                              await ProfileCubit.get(context)
                                                  .deleteAccount();
                                              await auth.signOut();
                                              if (mounted) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const LoginScreen()));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
