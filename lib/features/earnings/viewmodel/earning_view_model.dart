import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/shared/services/api_service.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

// Models
class WalletData {
  final double currentBalance;
  final double withdrawableBalance;
  final double pendingBalance;
  final double totalWithdrawn;
  final double totalEarned;

  WalletData({
    required this.currentBalance,
    required this.withdrawableBalance,
    required this.pendingBalance,
    required this.totalWithdrawn,
    required this.totalEarned,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      currentBalance: (json['currentBalance'] ?? 0).toDouble(),
      withdrawableBalance: (json['withdrawableBalance'] ?? 0).toDouble(),
      pendingBalance: (json['pendingBalance'] ?? 0).toDouble(),
      totalWithdrawn: (json['totalWithdrawn'] ?? 0).toDouble(),
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
    );
  }
}

class PayoutMethod {
  final String type; // bank, bkash, nagad, rocket
  final String accountName;
  final String accountNumber;
  final String? bankName;
  final String? branch;

  PayoutMethod({
    required this.type,
    required this.accountName,
    required this.accountNumber,
    this.bankName,
    this.branch,
  });

  factory PayoutMethod.fromJson(Map<String, dynamic> json) {
    return PayoutMethod(
      type: json['type'] ?? 'bkash',
      accountName: json['accountName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankName: json['bankName'],
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'type': type,
      'accountName': accountName,
      'accountNumber': accountNumber,
    };
    if (type == 'bank' && bankName != null) {
      map['bankName'] = bankName!;
    }
    if (branch != null) {
      map['branch'] = branch!;
    }
    return map;
  }
}

class Earning {
  final String id;
  final String serviceType;
  final double gross;
  final double doctorEarning;
  final String status;
  final String createdAt;

  Earning({
    required this.id,
    required this.serviceType,
    required this.gross,
    required this.doctorEarning,
    required this.status,
    required this.createdAt,
  });

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      id: json['id'] ?? '',
      serviceType: json['serviceType'] ?? '',
      gross: (json['gross'] ?? 0).toDouble(),
      doctorEarning: (json['doctorEarning'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class Payout {
  final String id;
  final double amount;
  final String status;
  final String timestamp;
  final String? paidAt;

  Payout({
    required this.id,
    required this.amount,
    required this.status,
    required this.timestamp,
    this.paidAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      paidAt: json['paidAt'],
    );
  }
}

class EarningViewModel extends ChangeNotifier {
  // Loading states
  bool isLoading = false;
  bool isWithdrawing = false;
  bool isSavingMethod = false;

  // Data
  WalletData? wallet;
  PayoutMethod? payoutMethod;
  double minWithdrawal = 500;
  List<Earning> earnings = [];
  List<Payout> payouts = [];

  // UI state
  String selectedSource = 'all';

  // Payout Method Form
  String payoutType = 'bkash';
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  // Withdrawal Form
  final TextEditingController withdrawalAmountController =
      TextEditingController();

  // Computed
  List<Earning> get filteredEarnings {
    if (selectedSource == 'all') return earnings;
    return earnings.where((e) => e.serviceType == selectedSource).toList();
  }

  void setSourceFilter(String source) {
    selectedSource = source;
    notifyListeners();
  }

  void setPayoutType(String type) {
    payoutType = type;
    notifyListeners();
  }

  String formatMoney(double amount) {
    return '৳${amount.toStringAsFixed(2)}';
  }

  // ---------- Load Wallet Data ----------
  Future<void> loadWallet() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse("${ApiServices.baseUrl}api/doctor/wallet"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Wallet Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Parse wallet
          if (data['wallet'] != null) {
            wallet = WalletData.fromJson(data['wallet']);
          }

          // Parse payout method
          if (data['payoutMethod'] != null) {
            payoutMethod = PayoutMethod.fromJson(data['payoutMethod']);

            // Pre-fill form with existing method
            payoutType = payoutMethod!.type;
            accountNameController.text = payoutMethod!.accountName;
            accountNumberController.text = payoutMethod!.accountNumber;
            bankNameController.text = payoutMethod!.bankName ?? '';
          }

          // Parse min withdrawal
          minWithdrawal = (data['minWithdrawalBdt'] ?? 500).toDouble();

          // Parse earnings
          if (data['earnings'] != null) {
            earnings =
                (data['earnings'] as List)
                    .map((e) => Earning.fromJson(e))
                    .toList();
          }

          // Parse payouts
          if (data['payouts'] != null) {
            payouts =
                (data['payouts'] as List)
                    .map((p) => Payout.fromJson(p))
                    .toList();
          }

          notifyListeners();
          debugPrint("✅ Wallet loaded successfully");
        }
      } else {
        throw Exception('Failed to load wallet: ${response.statusCode}');
      }
    } catch (err) {
      debugPrint("❌ Error loading wallet: $err");
      Fluttertoast.showToast(
        msg: "Failed to load wallet data",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------- Save Payout Method ----------
  Future<void> savePayoutMethod(BuildContext context) async {
    isSavingMethod = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return;

      final payload = {
        'type': payoutType,
        'accountName': accountNameController.text.trim(),
        'accountNumber': accountNumberController.text.trim(),
        if (payoutType == 'bank') 'bankName': bankNameController.text.trim(),
      };

      debugPrint("📤 Saving payout method: ${jsonEncode(payload)}");

      final response = await http.put(
        Uri.parse("${ApiServices.baseUrl}api/doctor/payout-method"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📥 Save Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: "Payout method saved successfully",
            backgroundColor: Colors.green,
          );

          // Reload wallet to get updated method
          await loadWallet();
        } else {
          throw Exception(data['error'] ?? 'Failed to save payout method');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to save payout method');
      }
    } catch (err) {
      debugPrint("❌ Error saving payout method: $err");
      Fluttertoast.showToast(msg: "Error: $err", backgroundColor: Colors.red);
    } finally {
      isSavingMethod = false;
      notifyListeners();
    }
  }

  // ---------- Request Withdrawal ----------
  Future<void> requestWithdrawal(BuildContext context) async {
    final amount = double.tryParse(withdrawalAmountController.text) ?? 0;

    if (amount < minWithdrawal) {
      print("Minimum withdrawal is ${formatMoney(minWithdrawal)}");
      Fluttertoast.showToast(
        msg: "Minimum withdrawal is ${formatMoney(minWithdrawal)}",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (wallet != null && amount > wallet!.withdrawableBalance) {
      Fluttertoast.showToast(
        msg: "Insufficient withdrawable balance",
        backgroundColor: Colors.red,
      );
      return;
    }

    isWithdrawing = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) return;

      final payload = {'amount': amount};

      debugPrint("📤 Requesting withdrawal: ${jsonEncode(payload)}");

      final response = await http.post(
        Uri.parse("${ApiServices.baseUrl}api/doctor/withdraw"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📥 Withdrawal Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: data['message'] ?? "Withdrawal requested successfully",
            backgroundColor: Colors.green,
          );

          // Clear form
          withdrawalAmountController.clear();

          // Reload wallet
          await loadWallet();
        } else {
          throw Exception(data['error'] ?? 'Withdrawal failed');
        }
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        final errorCode = errorData['code'];

        if (errorCode == 'NO_PAYOUT_METHOD') {
          Fluttertoast.showToast(
            msg: "Please add a payout method first",
            backgroundColor: Colors.orange,
          );
        } else {
          throw Exception(errorData['error'] ?? 'Invalid request');
        }
      } else if (response.statusCode == 409) {
        final errorData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: errorData['error'] ?? "You already have a pending request",
          backgroundColor: Colors.orange,
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Withdrawal failed');
      }
    } catch (err) {
      debugPrint("❌ Error requesting withdrawal: $err");
      Fluttertoast.showToast(msg: "Error: $err", backgroundColor: Colors.red);
    } finally {
      isWithdrawing = false;
      notifyListeners();
    }
  }

  // ---------- Helper: Get Auth Token ----------
  Future<String?> _getToken() async {
    try {
      final authProvider = AuthenticationProvider();
      final token = await authProvider.getFreshToken();

      if (token == null) {
        Fluttertoast.showToast(
          msg: "Authentication required. Please login again.",
          backgroundColor: Colors.red,
        );
        return null;
      }

      return token;
    } catch (e) {
      debugPrint("❌ Failed to get token: $e");
      Fluttertoast.showToast(
        msg: "Authentication error",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  @override
  void dispose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    withdrawalAmountController.dispose();
    super.dispose();
  }
}
