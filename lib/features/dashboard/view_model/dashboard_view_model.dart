import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  Future fetchDoctorData() async{
    try{

      FirebaseFirestore.instance.collection("doctors").doc().get();

    }catch(err){

    }finally{

    }
  }
}