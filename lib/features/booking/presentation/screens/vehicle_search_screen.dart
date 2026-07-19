import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_app/features/booking/presentation/screens/booking_summary_screen.dart';
import 'package:vehicle_rental_app/features/booking/providers/booking_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';


class VehicleSearchScreen extends ConsumerWidget {
  const VehicleSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Available Rides", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
      body: Builder(
        builder: (context) {
          if (state.status == BookingStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state.status == BookingStatus.error) {
            return Center(child: Padding(padding: EdgeInsets.all(24.w), child: Text(state.errorMessage ?? 'Search execution dropped.', style: TextStyle(color: AppColors.error, fontSize: 14.sp))));
          }
          if (state.vehicles.isEmpty) {
            return Center(child: Text("No vehicles listed for this choice context.", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)));
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = state.vehicles[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vehicle.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 4.h),
                        Text("Type: ${vehicle.type}", style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                        SizedBox(height: 2.h),
                        Text("Partner: ${vehicle.partnerName}", style: TextStyle(fontSize: 12.sp, color: AppColors.textLight)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("₹${vehicle.pricePerDay.toStringAsFixed(0)}/day", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            ref.read(bookingControllerProvider.notifier).selectVehicleForCheckout(vehicle);
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingSummaryScreen()));
                          },
                          child: Text("Rent", style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}