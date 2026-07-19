import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental_app/features/booking/providers/booking_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';


class BookingSummaryScreen extends ConsumerWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);
    final format = DateFormat('yyyy-MM-dd HH:mm');

    if (state.selectedVehicle == null || state.searchParams == null) {
      return const Scaffold(body: Center(child: Text("Context integrity failure.")));
    }

    final vehicle = state.selectedVehicle!;
    final params = state.searchParams!;
    final days = params.dropDateTime.difference(params.pickupDateTime).inDays;
    final cleanDays = days <= 0 ? 1 : days;
    final totalPrice = vehicle.pricePerDay * cleanDays;

    return Scaffold(
      appBar: AppBar(title: Text("Booking Summary", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Confirm Details", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text(vehicle.type, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                  const Divider(height: 24, color: AppColors.border),
                  _rowSummary("State", params.state),
                  _rowSummary("District", params.district),
                  _rowSummary("Hub Node", params.locationHubId),
                  _rowSummary("From", format.format(params.pickupDateTime)),
                  _rowSummary("Until", format.format(params.dropDateTime)),
                  const Divider(height: 24, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Price ($cleanDays Days)", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text("₹${totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), elevation: 0),
                onPressed: state.status == BookingStatus.processingCheckout
                    ? null
                    : () async {
                        final done = await ref.read(bookingControllerProvider.notifier).confirmBooking();
                        if (done && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reservation Scheduled Successfully!"), backgroundColor: AppColors.accent));
                          ref.read(bookingControllerProvider.notifier).resetState();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                child: state.status == BookingStatus.processingCheckout
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Secure Checkout", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _rowSummary(String label, String val) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
          Text(val, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}