import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preggo/colors.dart';

Widget listItems(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backGroundPink.withOpacity(0.3),
        border: Border.all(color: backGroundPink, width: 2),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Text(
            doc["weight"],
            style: TextStyle(),
          ),
          Text(doc["date"], style: TextStyle())
        ],
      ),
    ),
  );
}
