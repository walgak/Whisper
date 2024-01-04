//Return a formatted time as a String

import 'package:cloud_firestore/cloud_firestore.dart';

String formatTime( Timestamp timestamp){

  DateTime dateTime = timestamp.toDate();

  //get year
  String year = dateTime.year.toString();

  //get month
  String month = dateTime.month.toString();

  //get Day
  String day = dateTime.day.toString();

  //put them together
  String formattedDate = "$day/$month/$year";

  return formattedDate;
}