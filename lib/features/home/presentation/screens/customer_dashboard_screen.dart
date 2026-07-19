import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/providers/auth_providers.dart';
import '../../../booking/presentation/screens/booking_form_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart'; // Added navigation import

class CustomerDashboardScreen extends ConsumerWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final customerName = authState.user?.name ?? 'Valued Customer';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $customerName",
              style: TextStyle(
                fontSize: 18.sp, 
                fontWeight: FontWeight.bold, 
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Ready to find your next rental?",
              style: TextStyle(
                fontSize: 12.sp, 
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          // Profile Navigation
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.textPrimary),
            tooltip: 'My Portal',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          // Logout Action
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.error),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authControllerProvider.notifier).logoutCustomer();
            },
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Premium Partner Fleets",
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Rent high-quality vehicles verified directly from global certified partners.",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32.h),
              
              Text(
                "Quick Actions",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 16.h),
              
              // Booking CTA
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BookingFormScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Icon(Icons.time_to_leave_outlined, color: AppColors.primary),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Book a Rental Vehicle", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            SizedBox(height: 2.h),
                            Text("Filter by date, hub location, and partner configurations", style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 16, color: AppColors.textLight),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 32.h),
              
              Text("Your Active Rentals", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 16.h),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment_outlined, size: 40, color: AppColors.textLight),
                    SizedBox(height: 12.h),
                    Text("No active bookings found", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}