import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_request_model.dart';
import '../../data/repositories/booking_repository.dart';

enum BookingStatus { initial, loading, vehiclesLoaded, processingCheckout, success, error }

class BookingState {
  final BookingStatus status;
  final BookingRequestModel? searchParams;
  final List<VehicleModel> vehicles;
  final VehicleModel? selectedVehicle;
  final String? errorMessage;

  BookingState({
    required this.status,
    this.searchParams,
    this.vehicles = const [],
    this.selectedVehicle,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    BookingRequestModel? searchParams,
    List<VehicleModel>? vehicles,
    VehicleModel? selectedVehicle,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      searchParams: searchParams ?? this.searchParams,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BookingController extends StateNotifier<BookingState> {
  final BookingRepository _repository;

  BookingController(this._repository) : super(BookingState(status: BookingStatus.initial));

  Future<void> searchVehicles(BookingRequestModel params) async {
    state = state.copyWith(status: BookingStatus.loading, searchParams: params);
    try {
      final results = await _repository.searchAvailableVehicles(params);
      state = state.copyWith(status: BookingStatus.vehiclesLoaded, vehicles: results);
    } catch (e) {
      state = state.copyWith(status: BookingStatus.error, errorMessage: e.toString());
    }
  }

  void selectVehicleForCheckout(VehicleModel vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  Future<bool> confirmBooking() async {
    if (state.searchParams == null || state.selectedVehicle == null) return false;
    state = state.copyWith(status: BookingStatus.processingCheckout);
    try {
      final complete = await _repository.checkoutFinalReservation(
        state.searchParams!,
        state.selectedVehicle!.id,
      );
      if (complete) {
        state = state.copyWith(status: BookingStatus.success);
        return true;
      }
      state = state.copyWith(status: BookingStatus.error, errorMessage: "Booking could not be finalized.");
      return false;
    } catch (e) {
      state = state.copyWith(status: BookingStatus.error, errorMessage: e.toString());
      return false;
    }
  }
  
  void resetState() {
    state = BookingState(status: BookingStatus.initial);
  }
}