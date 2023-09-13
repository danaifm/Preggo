// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_init_to_null, unused_import, avoid_print, unused_element


import 'package:flutter/material.dart';
import 'package:preggo/SplashScreen.dart';
import 'package:preggo/colors.dart';
import 'package:preggo/main.dart';
import 'package:dropdown_search/dropdown_search.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class pregnancyInfo extends StatefulWidget {
  //const SignUp({Key? key}) : super(key: key);
  late final String userId  ;
  @override
  State<StatefulWidget> createState() {
    return _fillPregnancyInfo();
  }
}
  class _fillPregnancyInfo extends State<pregnancyInfo> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
    final TextEditingController _babynameController = TextEditingController();

    String? gender;
    var selectedWeek = null; 
    bool showError = false; 

    String getUserId(){
      User? user = FirebaseAuth.instance.currentUser;
      return user!.uid;
    }

    void addPregnancyInfo(String name, String gender, DateTime due){
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userUid = getUserId();

      CollectionReference subCollectionRef = firestore.collection('users').doc(userUid).collection('pregnancyInfo');
      subCollectionRef.add({
        'Baby\'s name': name,
        'Gender': gender,
        'DueDate': due,
      }).then((value) => print('info added successfully')).catchError((error) => print('failed to add info:$error'));
    }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold( 
      backgroundColor: backGroundPink,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(height: 55,),
          Text(
            "Add pregnancy details",
            style: TextStyle(
              color: Color(0xFFD77D7C),
              fontSize: 32,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              height: 1.30,
              letterSpacing: -0.28,
            ),
          ),

          SizedBox(height: 20,),
          Expanded(
            
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 0.0,),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(80.0),
                  ),
              ),
              child: SingleChildScrollView(
              //physics: NeverScrollableScrollPhysics(),

              child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container( //baby name label 
                              margin: EdgeInsets.only(top: 30,left: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Baby's name",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                height: 1.30,
                                letterSpacing: -0.28,
                                
                              ),
                            ),
                          ),
          
                          Padding( //baby name text field 
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              key: _nameKey,
                              controller: _babynameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                                focusedErrorBorder: OutlineInputBorder(
                                  gapPadding: 0.5,
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 0.50,
                                    color: Color.fromRGBO(255, 100, 100, 1),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  gapPadding: 0.5,
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 0.50,
                                    color: Color.fromRGBO(255, 100, 100, 1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  gapPadding: 0.5,
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 0.50,
                                    color: Color.fromARGB(255, 221, 225, 232),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // gapPadding: 100,
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 0.50,
                                    color: Color.fromARGB(255, 221, 225, 232),
                                  ),
                                ),
                                hintText: "Optional",
                                filled: true,
                                fillColor: Color(0xFFF7F8F9),
                              ),
                              validator: (value){
                                if(value!.isEmpty){return null;} //allow empty field

                                if(!RegExp(r'^[a-z A-Z]+$').hasMatch(value)){ 
                                  //allow upper and lower case alphabets and space if input is written 
                                  return "Please Enter letters only";
                                }
                                else{
                                  return null;
                                }
                              },
                              ),
                            ),//end of baby name text field 
          
                            Container( //babys gender label 
                              margin: EdgeInsets.only(top: 30,left: 5,bottom: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Baby's gender",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                height: 1.30,
                                letterSpacing: -0.28,
                                ),
                              ),
                            ),
          
                            Column( //gender radio buttons 
                              children: [
                                
                                RadioListTile(
                                  //key: _radioKey,
                                  visualDensity: const VisualDensity(vertical: -4.0),
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Color(0xFFD77D7C),
                                  title: Row(children: [Text('Girl'), SizedBox(width: 5,),Icon(Icons.female, color: Colors.black,)],),
                                  value: 'Girl', groupValue: gender, 
                                  onChanged: (val){setState(() {
                                  gender=val;
                                });
                                }//set state 
                                
                                ),
          
                                RadioListTile(
                                  visualDensity: const VisualDensity(vertical: -4.0),
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Color(0xFFD77D7C),
                                  title: Row(children: [Text('Boy'), SizedBox(width: 5,),Icon(Icons.male, color: Colors.black,)],),
                                  value: 'Boy', groupValue: gender, 
                                  onChanged: (val){setState(() {
                                    gender=val;
                                });
                                }//set state 
                                ),
          
                              RadioListTile(
                                visualDensity: const VisualDensity(vertical: -4.0),
                                contentPadding: EdgeInsets.zero,
                                activeColor: Color(0xFFD77D7C),
                                title: Row(children: [Text('Unknown'), SizedBox(width: 5,),Icon(Icons.question_mark, color: Colors.black,)],),
                                value: 'Unknown', groupValue: gender, 
                                onChanged: (val){setState(() {
                                  gender=val;
                                });
                                }//set state 
                                ),
                              ],//radio buttons
                              
                            ),//for radio buttons 


                            Visibility(
                              visible:  showError,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.5),
                                  child: Text('Please select an option', style: TextStyle(color:Color.fromARGB(255, 203, 51, 40),fontSize: 13), textAlign: TextAlign.left, )),
                              ),
                            ),
          
                            Container( //current pregnancy week label 
                              margin: EdgeInsets.only(top: 30,left: 5,bottom: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Current pregnancy week",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w700,
                                height: 1.30,
                                letterSpacing: -0.28,
                                ),
                              ),
                            ),
          
                            
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8,),
                                child: DropdownSearch<String>(
                                popupProps: PopupProps.dialog(
                                  showSelectedItems: true,
                                ),
                                items: ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5","Week 6", "Week 7", "Week 8", "Week 9", "Week 10",
                                        "Week 11", "Week 12", "Week 13", "Week 14", "Week 15","Week 16", "Week 17", "Week 18", "Week 19", "Week 20",
                                        "Week 21", "Week 22", "Week 23", "Week 24", "Week 25","Week 26", "Week 27", "Week 28", "Week 29", "Week 30",
                                        "Week 31", "Week 32", "Week 33", "Week 34", "Week 35","Week 36", "Week 37", "Week 38", "Week 39", "Week 40"],
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                    hintText: "Select current week",
                                    filled: true,
                                    fillColor: Color(0xFFF7F8F9),
                                    enabledBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromARGB(255, 221, 225, 232),
                                      ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      gapPadding: 0.5,
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 0.50,
                                        color: Color.fromRGBO(255, 100, 100, 1),
                                      ),
                                  ),
                                  ),
                                ),
                                onChanged: (week){
                                  setState(() {
                                    selectedWeek = week; 
                                  });
                                },
                                selectedItem: selectedWeek,
                                validator: (String? item){
                                  if (item == null)
                                    {return "Please select an option";}
                                  else
                                  {return null;} 
                                },
                                ),
                              ),

                              
          
                            Padding( //start journey button 
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  if (gender == null){
                                    showError= true; 
                                  }
                                  else{
                                    showError=false;
                                  }
                                  
                                });
                                
                                if (_formKey.currentState!.validate()){
                                  String babyName = _babynameController.text;
                                  String? babyGender = gender; 
                                  String currentWeek = selectedWeek;
                                  String weekNum = currentWeek.substring(5); 
                                  int weekNo = int.parse(weekNum); 

                                  calculateDueDate(int week){
                                    const fullTerm = 40; 
                                    int daysToAdd = (fullTerm-week)*7;
                                    DateTime currentDate = DateTime.now();
                                    DateTime calculatedDueDate = currentDate.add(Duration(days: daysToAdd));
                                    return calculatedDueDate;
                                  }
                                  DateTime dueDate = calculateDueDate(weekNo);
                                  addPregnancyInfo(babyName, babyGender!, dueDate);
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => SplashScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                padding: EdgeInsets.only(left: 90, top: 15, right: 110,bottom: 15),
                              ),
                              child: Text("Start Journey",softWrap: false ,),
                              
                            ),
                          ),
          
                      ]),
                    ),
                  ),
                  
                  
                ],
              ),
            ),
    
            ),
            ),
          ),
        ],
      )
    );
  }
}
