import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeolocationController extends GetxController {
  Position? position;

  Future<void> chargePositioned() async {
    position = await getCurrentLocation();
  }

  Future<LocationPermission> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permiso denegado permanentemente. Mostrar un mensaje al usuario.
        return LocationPermission.deniedForever;
      }
    }
    return permission;
  }

  Future<Position?> getCurrentLocation() async {
    LocationPermission permission = await _checkLocationPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } else {
      return null;
    }
  }
}
