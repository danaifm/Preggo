import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:preggo/colors.dart';

class ViewWeight extends StatefulWidget {
  const ViewWeight({super.key});

  @override
  _ViewWeight createState() => _ViewWeight();
}

class _ViewWeight extends State<ViewWeight> {
  final _formKey = GlobalKey<FormState>();

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }
    if (value.length > 3 || value.length <= 1) {
      return 'Please enter a correct weight.';
    }

    return null;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      //if form is valid perform the next action
      print("The form is validated");
    }
  }

  openAddDialog(Context) {
    //the weight form
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(500)),
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(children: [
                Text(
                  "Add new weight",
                  style: TextStyle(
                      fontSize: 20,
                      color: blackColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 125,
                      height: 40,
                      child: TextFormField(
                          style: TextStyle(fontSize: 15, color: blackColor),
                          decoration: InputDecoration(
                            hintText: "In Kg",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: blackColor)),
                          ),
                          // The validator receives the text that the user has entered.
                          validator: validateWeight),
                    ),

                    ElevatedButton(
                        onPressed: () => {(ViewWeight())},
                        child: const Text('Submit')),

                    // Container( I need to add a submit button
                    //   child: IconButton,
                    // )
                  ],
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundPink,
      floatingActionButton: Chip(
          //the add button
          backgroundColor: blackColor,
          onDeleted: () => openAddDialog(context),
          deleteIcon: Icon(
            Icons.add,
            color: whiteColor,
          ),
          label: Text(
            "Add weight",
            style: TextStyle(fontSize: 20, color: whiteColor),
          )),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "    My weights",
                style: TextStyle(
                  color: Color(0xFFD77D7C),
                  fontSize: 32,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                ),
              ),
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, Index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Image(
                          height: 50,
                          width: 30,
                          image: AssetImage("assets/images/dumbbell.png"),
                        ),
                        title: Text(
                          "65 Kg",
                          style: TextStyle(
                            fontSize: 28,
                            color: blackColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: redColor,
                        ),
                      ),
                    ),
                  );
                },

                //YOUR WORK GOES HERE
              ),
            ),
          ),
        ],
      ),
    );
  }
}
