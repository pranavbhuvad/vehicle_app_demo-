import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/repositories/booking_repository.dart';
import '../presentation/controllers/booking_controller.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return BookingRepository(client.dio);
});

final bookingControllerProvider = StateNotifierProvider<BookingController, BookingState>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingController(repository);
});