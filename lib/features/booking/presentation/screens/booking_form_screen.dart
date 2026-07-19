import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental_app/features/booking/presentation/screens/vehicle_search_screen.dart';
import 'package:vehicle_rental_app/features/booking/providers/booking_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/booking_request_model.dart';


class BookingFormScreen extends ConsumerStatefulWidget {
  const BookingFormScreen({super.key});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _hubController = TextEditingController();

  DateTime? _pickupDate;
  DateTime? _dropDate;

  Future<void> _pickDateTime(bool isPickup) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      final calculated = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isPickup) {
        _pickupDate = calculated;
      } else {
        _dropDate = calculated;
      }
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate() || _pickupDate == null || _dropDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please absolute dates and route points."), backgroundColor: AppColors.error),
      );
      return;
    }

    final queryModel = BookingRequestModel(
      pickupDateTime: _pickupDate!,
      dropDateTime: _dropDate!,
      state: _stateController.text.trim(),
      district: _districtController.text.trim(),
      locationHubId: _hubController.text.trim(),
    );

    ref.read(bookingControllerProvider.notifier).searchVehicles(queryModel);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VehicleSearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Rental', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Where & When?", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                SizedBox(height: 6.h),
                Text("Enter details to parse available partner fleets near you.", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                
                SizedBox(height: 28.h),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State', prefixIcon: Icon(Icons.map_outlined)),
                  validator: (v) => Validators.validateRequired(v, 'State'),
                ),
                SizedBox(height: 18.h),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(labelText: 'District', prefixIcon: Icon(Icons.location_city_outlined)),
                  validator: (v) => Validators.validateRequired(v, 'District'),
                ),
                SizedBox(height: 18.h),
                TextFormField(
                  controller: _hubController,
                  decoration: const InputDecoration(labelText: 'Location Hub ID', prefixIcon: Icon(Icons.hub_outlined)),
                  validator: (v) => Validators.validateRequired(v, 'Location Hub'),
                ),
                
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDateTime(true),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12.r), color: AppColors.surface),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pickup Time", style: TextStyle(fontSize: 12.sp, color: AppColors.textLight)),
                              SizedBox(height: 4.h),
                              Text(_pickupDate == null ? "Select" : format.format(_pickupDate!), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDateTime(false),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12.r), color: AppColors.surface),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Drop Time", style: TextStyle(fontSize: 12.sp, color: AppColors.textLight)),
                              SizedBox(height: 4.h),
                              Text(_dropDate == null ? "Select" : format.format(_dropDate!), style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), elevation: 0),
                    onPressed: _submitForm,
                    child: Text('Find Vehicles', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}