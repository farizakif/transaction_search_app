import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../config/api_config.dart';
import '../models/transaction_request.dart';
import '../utils/helpers.dart';

class ApiService {
  late final http.Client _client;
  static const Duration _timeout = ApiConfig.requestTimeout;

  ApiService() {
    // Create HttpClient with custom certificate handling
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    
    _client = IOClient(httpClient);
  }

  Future<Map<String, dynamic>> fetchReport(TransactionRequest request) async {
    try {
      final Uri uri = Uri.parse(kApiBaseUrl);
      final String body = jsonEncode(request.toJson());

      final http.Response response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(_timeout);

      final String responseBody = response.body;
      Map<String, dynamic>? jsonResponse;

      try {
        jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>?;
      } catch (_) {
        jsonResponse = {'rawResponse': responseBody};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse ?? <String, dynamic>{};
      } else {
        throw ApiException(
          'API Error: ${response.statusCode} - ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException('Connection failed: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}');
    } on Exception catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout')) {
        throw ApiException('Request timed out. Please try again.');
      }
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
