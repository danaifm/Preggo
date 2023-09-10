import 'package:flutter/material.dart';

class PregnancyTracking extends StatefulWidget {
  const PregnancyTracking({super.key});

  @override
  _PregnancyTracking createState() => _PregnancyTracking();
}

class _PregnancyTracking extends State<PregnancyTracking> {
  @override
  double itemWidth = 60.0;
  int itemCount = 40;
  int selected = 40;
  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 50);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            child: Text('week \n \n   $x')))),
                itemExtent: itemWidth,
              ))),
    );
  }
}
