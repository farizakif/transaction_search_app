
class ApiConfig {
  
  static const String baseUrl =
      'https://uat.onepay.com.my:65002/M1RSv1/M1RS.aspx';

  static const String merchantKey = 'aaabbbccc1987238812';
  static const String opName = 'WSC_GetReport';
  static const String reportType = 'M1-IV-TEST-API';
  static const String channel = 'ISO';
  static const String dateFormat = 'yyyy-MM-dd';
  static const int midLength = 15;
  static const int tidMaxLength = 20;
  static const int txnIdMaxLength = 20;
  static const int beneAcctNoMaxLength = 25;
  static const int prodCodeMaxLength = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  
}
