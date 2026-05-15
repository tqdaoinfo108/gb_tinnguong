/// Hằng số dùng chung toàn app.
class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  static const double radiusSmall  = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge  = 16.0;
  static const double radiusXL     = 24.0;

  static const double paddingSmall  = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge  = 24.0;

  static const double cardElevation = 0;

  // ---------------------------------------------------------------------------
  // Animation
  // ---------------------------------------------------------------------------
  static const Duration animFast   = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow   = Duration(milliseconds: 500);

  // ---------------------------------------------------------------------------
  // API
  // ---------------------------------------------------------------------------
  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms

  // ---------------------------------------------------------------------------
  // Storage Keys
  // ---------------------------------------------------------------------------
  static const String keyToken     = 'access_token';
  static const String keyUserId    = 'user_id';
  static const String keyUserName  = 'user_name';
  static const String keyFirstRun  = 'first_run';
}
