import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vehicle_rental_app/features/auth/providers/auth_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);

    final bool isLoggedIn = profileState.status == ProfileStatus.loaded;
    final String displayName = isLoggedIn ? profileState.name : 'Guest User';
    final String displaySubtitle = isLoggedIn
        ? profileState.email
        : 'Not signed in';
    final String initialLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : 'G';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBBE2F6), Color(0xFFF5FAFD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "24 CARRENTAL",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      children: [
                        _buildCircleIconButton(Icons.notifications_none),
                        SizedBox(width: 10.w),
                        _buildCircleIconButton(Icons.person_outline),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                  "My Portal",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "Account, bookings & documents",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 20.h),

                // User card layout
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: const Color(0xFF4290CD),
                        child: Text(
                          initialLetter,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              displaySubtitle,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Operational list items
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildPortalTile(
                        Icons.calendar_today_outlined,
                        "My Bookings",
                        () {},
                      ),
                      _buildPortalTile(
                        Icons.description_outlined,
                        "KYC Documents",
                        () {},
                      ),
                      _buildPortalTile(
                        Icons.account_balance_wallet_outlined,
                        "Wallet & Refunds",
                        () {},
                      ),
                      _buildPortalTile(
                        Icons.favorite_border_outlined,
                        "Saved Locations",
                        () {},
                      ),
                      _buildPortalTile(
                        Icons.settings_outlined,
                        "Settings",
                        () {},
                      ),
                      _buildPortalTile(
                        Icons.logout_outlined,
                        isLoggedIn ? "Log Out" : "Log In / Register",
                        () {
                          if (isLoggedIn) {
                            // 1. Clear the main Auth engine state
                            ref
                                .read(authControllerProvider.notifier)
                                .logoutCustomer();

                            // 2. Clear the local Profile dynamic state data to force the UI to flip back to Guest
                            ref
                                .read(profileControllerProvider.notifier)
                                .clearProfileSession();
                          } else {
                            // If a guest clicks it, simulate logging them right back in with the dummy profiles!
                            ref
                                .read(profileControllerProvider.notifier)
                                .loadUserProfile();
                          }
                        },
                        isDestructive: isLoggedIn,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20.sp),
    );
  }

  Widget _buildPortalTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          leading: Icon(
            icon,
            color: isDestructive ? Colors.redAccent : const Color(0xFF1E5D8C),
            size: 22.sp,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: AppColors.textLight,
            size: 18.sp,
          ),
        ),
        Divider(color: Colors.grey.withOpacity(0.1), height: 1),
      ],
    );
  }
}
