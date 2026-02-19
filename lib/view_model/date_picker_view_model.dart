import 'package:flutter/material.dart';

class DatePickerProvider extends ChangeNotifier {
  DateTime? _selectedDate;

  /// Set date manually
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Reset date
  void clearDate() {
    _selectedDate = null;
    notifyListeners();
  }

  /// Global date picker function
  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      _selectedDate = picked;
      notifyListeners();
    }
  }
}
