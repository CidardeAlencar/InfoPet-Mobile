import 'dart:async';
import 'package:flutter/material.dart';
//maps
import 'package:google_maps_flutter/google_maps_flutter.dart';
//lopcation
import 'package:location/location.dart';

class GPSScreen extends StatefulWidget {
  const GPSScreen({super.key});

  @override
  State<GPSScreen> createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationData? _currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    // Solicita permiso para acceder a la ubicación
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        // Obtiene la ubicación actual
        location.getLocation().then((locationData) {
          setState(() {
            _currentLocation = locationData;
          });
        });
      }
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-16.5205315, -68.2066503),
    zoom: 12.000,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-16.5197865, -68.1101769),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // Muestra la ubicación actual si está disponible
        markers: _currentLocation != null
            ? {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  infoWindow: InfoWindow(title: 'Tu ubicación actual'),
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Ver Mascota!'),
        icon: const Icon(Icons.pets),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
