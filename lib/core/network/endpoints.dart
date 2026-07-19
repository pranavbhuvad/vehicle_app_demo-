class Endpoints {
  Endpoints._(); // Prevents instantiation

  // FIXED: Changed to your real backend Base URL from document
  static const String baseUrl = "https://exxample.in/api"; 
  
  // Authentication Endpoints[cite: 1]
  static const String signup = "/auth/user/register"; // FIXED[cite: 1]
  static const String login = "/auth/user/login";       // FIXED[cite: 1]
  
  // Vehicle Endpoints[cite: 1]
  static const String searchVehicles = "/vehicles/search";
  
  // Booking Endpoints[cite: 1]
  static const String createBooking = "/bookings/initiate"; // FIXED[cite: 1]
}