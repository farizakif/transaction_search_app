import '../utils/helpers.dart';

class TransactionRequest {

  final DateTime startDate;
  final DateTime endDate;
  final String mid;
  final String? tid;
  final String? txnId;
  final String? beneAcctNo;
  final String? prodCode;
  final int? txnStatus;
  final int? maxRow;
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
