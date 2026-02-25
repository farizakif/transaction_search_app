import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import '../config/api_config.dart';

const String kApiBaseUrl = ApiConfig.baseUrl;
const String kMerchantKey = ApiConfig.merchantKey;
const String kOpName = ApiConfig.opName;
const String kReportType = ApiConfig.reportType;
const String kChannel = ApiConfig.channel;
const String kDateFormat = ApiConfig.dateFormat;
const int kMidMaxLength = ApiConfig.midLength;
const int kTidMaxLength = ApiConfig.tidMaxLength;
const int kTxnIdMaxLength = ApiConfig.txnIdMaxLength;
const int kBeneAcctNoMaxLength = ApiConfig.beneAcctNoMaxLength;
const int kProdCodeMaxLength = ApiConfig.prodCodeMaxLength;

String generateAuthToken({
  required String mid,
  String tid = '',
  String beneAcctNo = '',
}) {
  final String tidValue = tid.isEmpty ? '' : tid;
  final String beneAcctNoValue = beneAcctNo.isEmpty ? '' : beneAcctNo;

  final String concatenated =
      kMerchantKey + kChannel + mid + tidValue + beneAcctNoValue;

  final List<int> concatenatedBytes = utf8.encode(concatenated);
  final Digest innerHash = sha512.convert(concatenatedBytes);

  final String innerHashHex = innerHash.toString();
  final String outerInput = kMerchantKey + innerHashHex;
  final List<int> outerInputBytes = utf8.encode(outerInput);
  final Digest outerHash = sha512.convert(outerInputBytes);

  return outerHash.toString();
}

String formatDateForApi(DateTime date) {
  return DateFormat(kDateFormat).format(date);
}

DateTime? parseDateFromString(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateFormat(kDateFormat).parse(value);
  } catch (_) {
    return null;
  }
}

String? validateStartDate(DateTime? value) {
  if (value == null) {
    return 'Start date is required';
  }
  return null;
}

String? validateEndDate(DateTime? value, DateTime? startDate) {
  if (value == null) {
    return 'End date is required';
  }
  if (startDate != null && value.isBefore(startDate)) {
    return 'End date cannot be before start date';
  }
  return null;
}

String? validateMid(String? value) {
  if (value == null || value.isEmpty) {
    return 'MID is required';
  }
  if (value.length != kMidMaxLength) {
    return 'MID must be exactly $kMidMaxLength characters';
  }
  return null;
}

String? validateTid(String? value) {
  if (value != null && value.length > kTidMaxLength) {
    return 'TID must not exceed $kTidMaxLength characters';
  }
  return null;
}

String? validateTxnId(String? value) {
  if (value != null && value.length > kTxnIdMaxLength) {
    return 'TxnID must not exceed $kTxnIdMaxLength characters';
  }
  return null;
}

String? validateBeneAcctNo(String? value) {
  if (value != null && value.length > kBeneAcctNoMaxLength) {
    return 'BeneAcctNo must not exceed $kBeneAcctNoMaxLength characters';
  }
  return null;
}

String? validateProdCode(String? value) {
  if (value != null && value.length > kProdCodeMaxLength) {
    return 'ProdCode must not exceed $kProdCodeMaxLength characters';
  }
  return null;
}

String? validateTxnStatus(String? value) {
  if (value == null || value.isEmpty) return null;
  final int? parsed = int.tryParse(value);
  if (parsed == null) {
    return 'TxnStatus must be a valid integer';
  }
  return null;
}

String? validateMaxRow(String? value) {
  if (value == null || value.isEmpty) return null;
  final int? parsed = int.tryParse(value);
  if (parsed == null || parsed < 1) {
    return 'MaxRow must be a positive integer';
  }
  return null;
}
