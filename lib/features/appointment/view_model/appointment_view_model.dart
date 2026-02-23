import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class AppointmentViewModel extends ChangeNotifier {
  // ----------  Fetch appointments --------------
  bool isLoadingAppointmentsFetch = false;
  List appointmentsList = [];
  Future fetchDoctorsAppointments(BuildContext context) async {
    try {
      isLoadingAppointmentsFetch = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      // Always request fresh token
      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId; // or however you store doctorId
      if (doctorId == null || token == null) {
        print("DoctorId or token missing");
        return;
      }
      if (doctorId == null || token == null) {
        return;
      }

      final appointmentsFetchRoute =
          "https://www.wiocare.com/api/doctor/appointments?doctorId=${doctorId}";
      final response = await http.get(
        Uri.parse(appointmentsFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        appointmentsList = data["appointments"];
        notifyListeners();
        print("Data: $appointmentsList");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingAppointmentsFetch = false;
      notifyListeners();
    }
  }

  // -----------------  Fetch all appointments with pagination and query ----------------------
  bool isLoadingAllAppointmentsFetch = false;
  bool isPaginationLoading = false;
  String? fetchError;

  List allAppointmentsList = [];

  int currentPage = 1;
  bool hasMore = true;
  String currentQuery = "";
  Future fetchDoctorsAppointmentsAll(
    BuildContext context, {
    String query = "",
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore && !hasMore) return;

      if (isLoadMore) {
        isPaginationLoading = true;
      } else {
        isLoadingAllAppointmentsFetch = true;
        fetchError = null;
        currentPage = 1;
        hasMore = true;
        allAppointmentsList.clear();
        currentQuery = query;
      }

      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        fetchError = "Authentication error";
        return;
      }

      final url =
          "https://www.wiocare.com/api/doctor/appointments"
          "?doctorId=$doctorId"
          "&search=$currentQuery"
          "&page=$currentPage"
          "&limit=10";

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List newData = data["appointments"] ?? [];

        if (isLoadMore) {
          allAppointmentsList.addAll(newData);
        } else {
          allAppointmentsList = newData;
        }

        if (newData.length < 10) {
          hasMore = false;
        } else {
          currentPage++;
        }
      } else {
        fetchError = "Failed to load appointments";
      }
    } catch (e) {
      fetchError = e.toString();
    } finally {
      isLoadingAllAppointmentsFetch = false;
      isPaginationLoading = false;
      notifyListeners();
    }
  }
}
