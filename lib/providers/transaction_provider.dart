import 'package:flutter/foundation.dart';
import '../models/transaction_request.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';

enum TransactionState {
  initial,
  loading,
  success,
  error,
}

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  TransactionState _state = TransactionState.initial;
  TransactionState get state => _state;
  Map<String, dynamic>? _responseData;
  Map<String, dynamic>? get responseData => _responseData;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  TransactionRequest? _lastRequest;
  TransactionRequest? get lastRequest => _lastRequest;


  Future<void> searchTransactions({
    required DateTime startDate,
    required DateTime endDate,
    required String mid,
    String? tid,
    String? txnId,
    String? beneAcctNo,
    String? prodCode,
    int? txnStatus,
    int? maxRow,
  }) async {
    _state = TransactionState.loading;
    _errorMessage = null;
    _responseData = null;
    notifyListeners();

    try {
      final String authToken = generateAuthToken(
        mid: mid,
        tid: tid ?? '',
        beneAcctNo: beneAcctNo ?? '',
      );

      _lastRequest = TransactionRequest(
        startDate: startDate,
        endDate: endDate,
        mid: mid,
        tid: tid?.isEmpty ?? true ? null : tid,
        txnId: txnId?.isEmpty ?? true ? null : txnId,
        beneAcctNo: beneAcctNo?.isEmpty ?? true ? null : beneAcctNo,
        prodCode: prodCode?.isEmpty ?? true ? null : prodCode,
        txnStatus: txnStatus,
        maxRow: maxRow,
        authToken: authToken,
      );

      final Map<String, dynamic> result =
          await _apiService.fetchReport(_lastRequest!);

      _responseData = result;
      _state = TransactionState.success;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = TransactionState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = TransactionState.error;
      notifyListeners();
    }
  }


  void reset() {
    _state = TransactionState.initial;
    _responseData = null;
    _errorMessage = null;
    _lastRequest = null;
    notifyListeners();
  }
  

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
