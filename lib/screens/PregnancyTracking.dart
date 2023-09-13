import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PregnancyTracking extends StatefulWidget {
  const PregnancyTracking({super.key});

  @override
  _PregnancyTracking createState() => _PregnancyTracking();
}

class _PregnancyTracking extends State<PregnancyTracking> {
  double itemWidth = 60.0;
  int itemCount = 40;
  int selected = 2;
  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 50);
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            child: RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView(
                  magnification: 2.0,
                  onSelectedItemChanged: (x) {
                    setState(() {
                      selected = x;
                    });
                    print(selected);
                  },
                  controller: _scrollController,
                  children: List.generate(
                      itemCount,
                      (x) => RotatedBox(
                          quarterTurns: 1,
                          child: AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              width: x == selected ? 70 : 60,
                              height: x == selected ? 80 : 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: x == selected
                                      ? Color.fromRGBO(249, 220, 222, 1)
                                      : Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                'week \n \n    ${x + 1}', // so it starts from week 1
                                style: TextStyle(fontFamily: 'Urbanist'),
                              )))),
                  itemExtent: itemWidth,
                )),
          ),
          Row(
            children: [
              //weight icon
              Container(
                  width: 90,
                  height: 70,
                  child: Column(
                    children: [
                      Icon(
                        Icons.monitor_weight_outlined,
                        color: Color.fromARGB(255, 163, 39, 39),
                      ),
                      Text(
                        '39.9 kg',
                        style: TextStyle(fontFamily: 'Urbanist', fontSize: 15),
                      ),
                      Text(
                        'Weight',
                        style: TextStyle(fontFamily: 'Urbanist', fontSize: 12),
                      )
                    ],
                  )),
              Container(
                //baby pic
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/w01-02.jpg')),
                    borderRadius: BorderRadius.circular(500)),
              ),

              Container(
                  //length icon
                  width: 90,
                  height: 70,
                  child: Column(
                    children: [
                      Icon(Icons.straighten, color: Colors.teal[800]),
                      Text(
                        '39.9 cm',
                        style: TextStyle(fontFamily: 'Urbanist', fontSize: 15),
                      ),
                      Text(
                        'height',
                        style: TextStyle(fontFamily: 'Urbanist', fontSize: 12),
                      )
                    ],
                  )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 300,
            width: 330,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Color.fromRGBO(249, 220, 222, 1), width: 1.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2, spreadRadius: 0.5, color: Colors.grey)
                ]),
          )
        ],
      ),
    );
  }
}
