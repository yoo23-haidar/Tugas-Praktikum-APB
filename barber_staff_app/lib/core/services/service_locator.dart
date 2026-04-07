import 'package:barber_staff_app/core/services/barber_service_base.dart';
import 'package:barber_staff_app/core/services/barber_api_service.dart';
import 'package:barber_staff_app/core/services/mock_barber_service.dart';

/// Simple service locator to toggle between mock and production services.
///
/// Set [useMock] to `false` and provide a [baseUrl] before release.
///
/// ```dart
/// // In main.dart or startup:
/// ServiceLocator.init(useMock: true);
/// final service = ServiceLocator.barberService;
/// ```
class ServiceLocator {
  ServiceLocator._();

  static BarberServiceBase? _instance;

  /// Initialize the service layer.
  /// Call once at app startup (e.g. in `main()`).
  static void init({
    bool useMock = true,
    String baseUrl = 'https://api.barber.id/v1',
  }) {
    if (useMock) {
      _instance = MockBarberService();
    } else {
      _instance = BarberApiService(baseUrl: baseUrl);
    }
  }

  /// Access the active service instance.
  static BarberServiceBase get barberService {
    if (_instance == null) {
      throw StateError(
        'ServiceLocator not initialized. Call ServiceLocator.init() first.',
      );
    }
    return _instance!;
  }

  /// Replace at runtime (useful for tests).
  static void override(BarberServiceBase service) {
    _instance = service;
  }
}
