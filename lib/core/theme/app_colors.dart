import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevents instantiation

  // Brand Core Colors
  static const Color primary = Color(0xFF2563EB);       // Modern Premium Blue
  static const Color primaryDark = Color(0xFF1D4ED8);   // Active press state tone
  static const Color accent = Color(0xFF10B981);        // Mint green for confirmations

  // Backgrounds & Surface Textures
  static const Color background = Color(0xFFF8FAFC);    // Screen scaffolding tint
  static const Color surface = Color(0xFFFFFFFF);       // Card background element base
  static const Color border = Color(0xFFE2E8F0);        // Input borders and clean dividers

  // Semantic Validation Feedback
  static const Color error = Color(0xFFEF4444);         // Validation failures or dynamic exceptions
  static const Color warning = Color(0xFFF59E0B);       // Warnings

  // Typography Tokens
  static const Color textPrimary = Color(0xFF0F172A);   // Titles and high-density labels
  static const Color textSecondary = Color(0xFF64748B); // Inline descriptions and captions
  static const Color textLight = Color(0xFF94A3B8);     // Placeholders and inactive labels
}