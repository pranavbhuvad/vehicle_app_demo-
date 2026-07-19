import 'package:dio/dio.dart';
import '../../../../core/network/endpoints.dart';
import '../models/booking_request_model.dart';

class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  Future<List<VehicleModel>> searchAvailableVehicles(BookingRequestModel query) async {
    try {
      final response = await _dio.get(
        Endpoints.searchVehicles,
        queryParameters: query.toJson(),
      );
      final list = response.data['vehicles'] as List<dynamic>;
      return list.map((item) => VehicleModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to retrieve match listings.');
    }
  }

  Future<bool> checkoutFinalReservation(BookingRequestModel details, String vehicleId) async {
    try {
      final response = await _dio.post(
        Endpoints.createBooking,
        data: {
          ...details.toJson(),
          'vehicle_id': vehicleId,
        },
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Reservation confirmation declined.');
    }
  }
}