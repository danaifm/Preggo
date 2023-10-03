import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  _ToolsPage createState() => _ToolsPage();
}

class _ToolsPage extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, top: 45),
            child: RichText(
              text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Tools\n',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: ' Use our tools to make your journey easier',
                        style: TextStyle(
                            color: Color.fromARGB(255, 121, 119, 119))),
                  ]),
            )),
        Container(
          // the boxes
          margin: EdgeInsets.only(top: 85),
          padding: EdgeInsets.all(15), // the spaces between the boxes
          child: GridView(
            children: [
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 81, 159, 224),
                          Color.fromARGB(255, 165, 194, 217)
                        ],
                        begin: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/schedule.png",
                        height: 100,
                      ),
                      Text(
                        "Appointments",
                        style: TextStyle(
                            fontFamily: "Urbainst",
                            fontSize: 16,
                            color: whiteColor),
                      )
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 221, 129, 123),
                          Color.fromARGB(255, 211, 155, 151)
                        ],
                        begin: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20))),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Color.fromARGB(255, 142, 210, 145)
                        ],
                        begin: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20))),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 221, 208, 95),
                          Color.fromARGB(255, 219, 215, 186)
                        ],
                        begin: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20)))
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.60),
          ),
        )
      ],
    ));
  }
}
