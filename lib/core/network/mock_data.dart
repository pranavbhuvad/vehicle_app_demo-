class MockData {
  MockData._();

  // Dummy Auth Success Response
  static final Map<String, dynamic> loginRegisterResponse = {
    "token": "dummy_jwt_token_xyz_123_rideflex",
    "user": {
      "id": "usr_987654",
      "name": "Pranav Bhuvad",
      "email": "abc@gmail.com",
      "phone": "8888888888"
    }
  };

  // Dummy profile info response
  static final Map<String, dynamic> userProfileResponse = {
    "user": {
      "id": "usr_987654",
      "name": "Pranav Bhuvad",
      "email": "abc@gmail.com",
      "phone": "8888888888"
    }
  };

  // Dummy Vehicle Search Listings
  static final Map<String, dynamic> vehicleSearchResponse = {
    "vehicles": [
      {
        "id": "vh_001",
        "name": "Hyundai Verna",
        "type": "Sedan",
        "price_per_day": 2500.0,
        "partner_name": "Sarg Softech Fleet",
        "is_available": true
      },
      {
        "id": "vh_002",
        "name": "Mahindra XUV700",
        "type": "SUV",
        "price_per_day": 4500.0,
        "partner_name": "Biencaps Rentals",
        "is_available": true
      },
      {
        "id": "vh_003",
        "name": "Tata Altroz",
        "type": "Hatchback",
        "price_per_day": 1800.0,
        "partner_name": "Pune Hub Rentals",
        "is_available": true
      }
    ]
  };

  // Dummy Booking Confirmation Response
  static final Map<String, dynamic> bookingConfirmResponse = {
    "success": true,
    "message": "Reservation initialized successfully",
    "booking_id": "bk_55019"
  };
}