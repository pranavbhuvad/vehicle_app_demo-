import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';
import 'endpoints.dart';
import 'mock_data.dart'; // Import mock collection data

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({Dio? dioClient, FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _dio = dioClient ?? Dio(
          BaseOptions(
            baseUrl: Endpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _initializeInterceptors();
  }

  Dio get dio => _dio;

  void _initializeInterceptors() {
    // 1. Authorization Header Handler
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = await _secureStorage.read(key: StorageKeys.authToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // 2. Mocking Interceptor + Console Logging Interceptor combined
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Keep request logging perfectly visible in terminal
          debugPrint('\n--- 🚀 OUTGOING API REQUEST ---');
          debugPrint('URL: ${options.baseUrl}${options.path}');
          debugPrint('Method: ${options.method}');
          if (options.data != null) {
            debugPrint('Request Body: ${jsonEncode(options.data)}');
          }
          debugPrint('--------------------------------\n');

          // INTERCEPT HERE: Match endpoints and return dummy data immediately
          Map<String, dynamic> mockJsonResponse = {};

          if (options.path == Endpoints.signup || options.path == Endpoints.login) {
            mockJsonResponse = MockData.loginRegisterResponse;
          } else if (options.path == Endpoints.searchVehicles) {
            mockJsonResponse = MockData.vehicleSearchResponse;
          } else if (options.path == Endpoints.createBooking) {
            mockJsonResponse = MockData.bookingConfirmResponse;
          } else {
            // Default generic validation backup response
            mockJsonResponse = {"success": true, "message": "Dummy mock baseline catch."};
          }

          // Force resolve a successful HTTP Response locally
          return handler.resolve(
            Response(
              requestOptions: options,
              data: mockJsonResponse,
              statusCode: 200,
            ),
          );
        },
        onResponse: (response, handler) {
          // Log incoming injected response mapping cleanly
          debugPrint('\n--- ✅ INCOMING MOCK RESPONSE ---');
          debugPrint('URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
          debugPrint('Status Code: ${response.statusCode}');
          debugPrint('Response Payload: ${jsonEncode(response.data)}');
          debugPrint('---------------------------------\n');
          return handler.next(response);
        },
      ),
    );
  }
}