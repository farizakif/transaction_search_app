import '../utils/helpers.dart';

/// ============================================================================
/// TRANSACTION REQUEST MODEL
/// Represents the search criteria for the M1RS GetReport API
/// ============================================================================

class TransactionRequest {
  /// Start date for the report (Required, Format: yyyy-mm-dd)
  final DateTime startDate;

  /// End date for the report (Required, Format: yyyy-mm-dd)
  final DateTime endDate;

  /// Merchant ID (Required, 15 bytes)
  final String mid;

  /// Terminal ID (Optional, 20 bytes)
  final String? tid;

  /// Transaction ID (Optional, 20 bytes)
  final String? txnId;

  /// Beneficiary Account Number (Optional, 25 bytes)
  final String? beneAcctNo;

  /// Product Code (Optional, 3 bytes)
  final String? prodCode;

  /// Transaction Status (Optional, Integer)
  final int? txnStatus;

  /// Maximum rows to return (Optional, Integer)
  final int? maxRow;

  /// AuthToken generated via SHA512 hashing (computed, not user input)
  final String authToken;

  TransactionRequest({
    required this.startDate,
    required this.endDate,
    required this.mid,
    this.tid,
    this.txnId,
    this.beneAcctNo,
    this.prodCode,
    this.txnStatus,
    this.maxRow,
    required this.authToken,
  });

  /// Converts the request to a JSON map for API POST body
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'OpName': kOpName,
      'ReportType': kReportType,
      'Channel': kChannel,
      'StartDate': formatDateForApi(startDate),
      'EndDate': formatDateForApi(endDate),
      'MID': mid,
      'AuthToken': authToken,
    };

    // Add optional parameters only if they have values
    if (tid != null && tid!.isNotEmpty) {
      map['TID'] = tid;
    }
    if (txnId != null && txnId!.isNotEmpty) {
      map['TxnID'] = txnId;
    }
    if (beneAcctNo != null && beneAcctNo!.isNotEmpty) {
      map['BeneAcctNo'] = beneAcctNo;
    }
    if (prodCode != null && prodCode!.isNotEmpty) {
      map['ProdCode'] = prodCode;
    }
    if (txnStatus != null) {
      map['TxnStatus'] = txnStatus;
    }
    if (maxRow != null) {
      map['MaxRow'] = maxRow;
    }

    return map;
  }
}
