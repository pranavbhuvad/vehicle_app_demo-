class Validators {
  Validators._(); // Prevents instantiation

  /// Validates standard customer email addresses
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Ensures login/signup entries meet functional safety parameters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  /// Validates common mobile phone numbers (10 digits standard format)
  static String? validatePhone(String? value) {
    // Since it's optional, if the input is completely empty, skip validation completely.
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    // Strict match configuration: matches standard international country prefixes followed by exactly 10 digits
    final phoneRegex = RegExp(r'^(?:\+?\d{1,3})?[-.\s]?[0-9]{10}$');
    
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  /// Asserts that required form data inputs (State, District, Dropdowns) are not submitted blank
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is strictly required';
    }
    return null;
  }
}