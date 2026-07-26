import 'package:flutter/foundation.dart';

typedef ReportVerificationStatus = String;
typedef ReportVerificationOutcome = String;

class ReportVerificationMirror {
  final String verificationId;
  final ReportVerificationStatus status;
  final String? verifierName;
  final String? verifiedAt;
  final String? comments;
  final bool? invalidated;

  ReportVerificationMirror({
    required this.verificationId,
    required this.status,
    this.verifierName,
    this.verifiedAt,
    this.comments,
    this.invalidated,
  });

  factory ReportVerificationMirror.fromJson(Map<String, dynamic> json) {
    return ReportVerificationMirror(
      verificationId: json['verificationId'] ?? '',
      status: json['status'] ?? 'requested',
      verifierName: json['verifierName'],
      verifiedAt: json['verifiedAt'],
      comments: json['comments'],
      invalidated: json['invalidated'],
    );
  }
}

class ReportAnalysis {
  final String? reportContent;
  final List<Map<String, dynamic>>? tests;
  final List<Map<String, dynamic>>? detectedConditions;
  final Map<String, dynamic>? dietarySuggestions;
  final Map<String, dynamic>? finalSummary;

  ReportAnalysis({
    this.reportContent,
    this.tests,
    this.detectedConditions,
    this.dietarySuggestions,
    this.finalSummary,
  });

  factory ReportAnalysis.fromJson(Map<String, dynamic> json) {
    return ReportAnalysis(
      reportContent: json['reportContent'],
      tests:
          json['tests'] != null
              ? List<Map<String, dynamic>>.from(json['tests'])
              : null,
      detectedConditions:
          json['detectedConditions'] != null
              ? List<Map<String, dynamic>>.from(json['detectedConditions'])
              : null,
      dietarySuggestions: json['dietarySuggestions'],
      finalSummary: json['finalSummary'],
    );
  }
}

class ReportData {
  final String? type;
  final String? provider;
  final String? date;
  final ReportAnalysis? analysis;
  final String? documentUrl;

  ReportData({
    this.type,
    this.provider,
    this.date,
    this.analysis,
    this.documentUrl,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      type: json['type'],
      provider: json['provider'],
      date: json['date'],
      analysis:
          json['analysis'] != null
              ? ReportAnalysis.fromJson(json['analysis'])
              : null,
      documentUrl: json['documentUrl'],
    );
  }
}

class VerificationDetail {
  final String verificationId;
  final String reportId;
  final ReportVerificationStatus status;
  final String? verifierId;
  final String? comments;
  final String? outcome;
  final String? createdAt;
  final String? claimedAt;
  final String? verifiedAt;
  final ReportData report;

  VerificationDetail({
    required this.verificationId,
    required this.reportId,
    required this.status,
    this.verifierId,
    this.comments,
    this.outcome,
    this.createdAt,
    this.claimedAt,
    this.verifiedAt,
    required this.report,
  });

  factory VerificationDetail.fromJson(Map<String, dynamic> json) {
    return VerificationDetail(
      verificationId: json['verificationId'] ?? '',
      reportId: json['reportId'] ?? '',
      status: json['status'] ?? 'requested',
      verifierId: json['verifierId'],
      comments: json['comments'],
      outcome: json['outcome'],
      createdAt: json['createdAt'],
      claimedAt: json['claimedAt'],
      verifiedAt: json['verifiedAt'],
      report: ReportData.fromJson(json['report'] ?? {}),
    );
  }
}

class VerifierQueueItem {
  final String verificationId;
  final String reportId;
  final String? patientId;
  final ReportVerificationStatus status;
  final String? reportType;
  final String? reportProvider;
  final String? reportDate;
  final String? verifierId;
  final String? createdAt;
  final String? claimedAt;

  VerifierQueueItem({
    required this.verificationId,
    required this.reportId,
    this.patientId,
    required this.status,
    this.reportType,
    this.reportProvider,
    this.reportDate,
    this.verifierId,
    this.createdAt,
    this.claimedAt,
  });

  factory VerifierQueueItem.fromJson(Map<String, dynamic> json) {
    return VerifierQueueItem(
      verificationId: json['verificationId'] ?? '',
      reportId: json['reportId'] ?? '',
      patientId: json['patientId'],
      status: json['status'] ?? 'requested',
      reportType: json['reportType'],
      reportProvider: json['reportProvider'],
      reportDate: json['reportDate'],
      verifierId: json['verifierId'],
      createdAt: json['createdAt'],
      claimedAt: json['claimedAt'],
    );
  }

  bool get isOpen => status == 'requested';
  bool get isClaimed => status == 'claimed';
  bool get isVerified => status == 'verified';
}
