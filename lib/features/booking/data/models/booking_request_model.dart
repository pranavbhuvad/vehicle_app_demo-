class BookingRequestModel {
  final DateTime pickupDateTime;
  final DateTime dropDateTime;
  final String state;
  final String district;
  final String locationHubId;

  BookingRequestModel({
    required this.pickupDateTime,
    required this.dropDateTime,
    required this.state,
    required this.district,
    required this.locationHubId,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup_datetime': pickupDateTime.toIso8601String(),
      'drop_datetime': dropDateTime.toIso8601String(),
      'state': state,
      'district': district,
      'location_hub_id': locationHubId,
    };
  }

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      pickupDateTime: DateTime.parse(json['pickup_datetime']),
      dropDateTime: DateTime.parse(json['drop_datetime']),
      state: json['state'] as String,
      district: json['district'] as String,
      locationHubId: json['location_hub_id'] as String,
    );
  }
}

class VehicleModel {
  final String id;
  final String name;
  final String type;
  final double pricePerDay;
  final String partnerName;
  final bool isAvailable;

  VehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerDay,
    required this.partnerName,
    required this.isAvailable,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      pricePerDay: (json['price_per_day'] as num).toDouble(),
      partnerName: json['partner_name'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }
}