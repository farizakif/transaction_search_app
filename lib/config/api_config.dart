
class ApiConfig {
  
  static const String baseUrl =
      'https://uat.onepay.com.my:65002/M1RSv1/M1RS.aspx';

  /// Secret merchant key used for AuthToken generation (SHA512)
  /// **IMPORTANT:** Keep this confidential and never commit to public repo
  static const String merchantKey = 'aaabbbccc1987238812';

  // =========================================================================
  // FIXED API PARAMETERS (Non-user-configurable)
  // =========================================================================

  /// Operation Name - GetReport (Fixed)
  static const String opName = 'WSC_GetReport';

  /// Report Type - M1 IV TEST API (Fixed)
  static const String reportType = 'M1-IV-TEST-API';

  /// Channel identifier - ISO (Fixed, 3 bytes)
  static const String channel = 'ISO';

  // =========================================================================
  // DATE FORMAT
  // =========================================================================

  /// API-required date format
  static const String dateFormat = 'yyyy-MM-dd';

  // =========================================================================
  // FIELD LENGTH CONSTRAINTS (Bytes/Characters)
  // =========================================================================

  /// Merchant ID - Required, exactly 15 characters
  static const int midLength = 15;

  /// Terminal ID - Optional, max 20 characters
  static const int tidMaxLength = 20;

  /// Transaction ID - Optional, max 20 characters
  static const int txnIdMaxLength = 20;

  /// Beneficiary Account Number - Optional, max 25 characters
  static const int beneAcctNoMaxLength = 25;

  /// Product Code - Optional, max 3 characters
  static const int prodCodeMaxLength = 3;

  // =========================================================================
  // HTTP CONFIGURATION
  // =========================================================================

  /// Timeout duration for API calls
  static const Duration requestTimeout = Duration(seconds: 30);

  // =========================================================================
  // API PARAMETER REFERENCE (For Documentation)
  // =========================================================================
  ///
  /// **REQUIRED PARAMETERS:**
  /// - OpName: String (Fixed: "WSC_GetReport")
  /// - ReportType: String (Fixed: "M1-IV-TEST-API")
  /// - Channel: String (Fixed: "ISO", 3 bytes)
  /// - StartDate: String (yyyy-mm-dd format, required user input)
  /// - EndDate: String (yyyy-mm-dd format, required user input)
  /// - MID: String (15 bytes, required user input)
  /// - AuthToken: String (SHA512 computed, not user input)
  ///
  /// **OPTIONAL PARAMETERS:**
  /// - TID: String (20 bytes max, optional user input)
  /// - TxnID: String (20 bytes max, optional user input)
  /// - BeneAcctNo: String (25 bytes max, optional user input)
  /// - ProdCode: String (3 bytes max, optional user input)
  /// - TxnStatus: Integer (optional user input)
  /// - MaxRow: Integer (optional user input)
  ///
  /// **AUTH TOKEN CALCULATION (SHA512):**
  /// 1. Concatenate: MerchantKey + Channel + MID + TID + BeneAcctNo
  ///    (Use empty string "" for missing optional params)
  /// 2. InnerHash = SHA512(concatenated_string)
  /// 3. OuterHash = SHA512(MerchantKey + InnerHash_HexString)
  /// 4. AuthToken = OuterHash (as hex string)
  ///
}
