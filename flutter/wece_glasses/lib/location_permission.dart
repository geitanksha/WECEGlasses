import 'package:location/location.dart';
import 'package:wece_glasses/globals.dart';

void requestLocationAccess() async {
  bool serviceEnabled = await location.serviceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return;
    }
  }
  PermissionStatus permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}
