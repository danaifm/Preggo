import 'package:preggo/screens/PregnancyTracking.dart';
import 'package:preggo/screens/CommunityPage.dart';
import 'package:preggo/screens/ProfilePage.dart';
import 'package:preggo/screens/ToolsPage.dart';
import 'package:preggo/screens/ArticlesPage.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int currentTab = 0;
  final List<Widget> screens = [
    PregnancyTracking(), //0
    CommunityPage(), //1
    ProfilePage(), //2
    ToolsPage(), //3
    ArticlesPage() //4
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = PregnancyTracking();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),

      // the profile page
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD77D7C),
        onPressed: () {
          setState(() {
            currentScreen = ProfilePage();
            currentTab = 2;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pregnant_woman_rounded,
              size: 35,
              color: currentTab == 2 ? Colors.white : Colors.white,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // the pregnancy tracking page
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = PregnancyTracking();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.home_filled,
                          color:
                              currentTab == 0 ? Color(0xFFD77D7C) : Colors.grey,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: currentTab == 0
                                  ? Color(0xFFD77D7C)
                                  : Colors.grey,
                              fontFamily: 'Signika'),
                        )
                      ],
                    ),
                  ),

                  // the community page
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = CommunityPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.language,
                          color:
                              currentTab == 1 ? Color(0xFFD77D7C) : Colors.grey,
                        ),
                        Text(
                          "Community",
                          style: TextStyle(
                              color: currentTab == 1
                                  ? Color(0xFFD77D7C)
                                  : Colors.grey,
                              fontFamily: 'Signika'),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              //Right Tab Bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // tools page
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ToolsPage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.brush,
                          color:
                              currentTab == 3 ? Color(0xFFD77D7C) : Colors.grey,
                        ),
                        Text(
                          "Tools",
                          style: TextStyle(
                            fontFamily: 'Signika',
                            color: currentTab == 3
                                ? Color(0xFFD77D7C)
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),

                  // Articles page
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = ArticlesPage();
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 30,
                          Icons.description,
                          color:
                              currentTab == 4 ? Color(0xFFD77D7C) : Colors.grey,
                        ),
                        Text(
                          "Articles",
                          style: TextStyle(
                              color: currentTab == 4
                                  ? Color(0xFFD77D7C)
                                  : Colors.grey,
                              fontFamily: 'Signika'),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
