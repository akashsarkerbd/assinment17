import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();
  LocationData? initialLocation;
  LocationData? currentLocation;
  late StreamSubscription locationSubscription;
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Real-Time Location Tracker",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.80525621032685, 90.41280160761826),
        ),
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('my-current-location'),
            position: LatLng(
              currentLocation?.latitude ?? 23.80525621032685,
              currentLocation?.longitude ?? 90.41280160761826,
            ),
            infoWindow: InfoWindow(
              title: "My Current Location",
              snippet:
                  '${currentLocation?.latitude} , ${currentLocation?.longitude}',
            ),
          ),
        },

        polylines: {
          Polyline(
            polylineId: const PolylineId('initial-location'),
            width: 5,
            color: Colors.blueAccent,
            points: [
              LatLng(
                initialLocation?.latitude ?? 23.80525621032685,
                initialLocation?.longitude ?? 90.41280160761826,
              ),
              LatLng(
                currentLocation?.latitude ?? 23.80525621032685,
                currentLocation?.longitude ?? 90.41280160761826,
              ),
            ],
          ),
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getInitialLocation();
  }

  void getCurrentLocation() {
    locationSubscription = location.onLocationChanged.listen((liveLocation) {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        currentLocation = liveLocation;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(liveLocation.latitude ?? 23.80525621032685,
                  liveLocation.longitude ?? 90.41280160761826),
              zoom: 17,
            ),
          ),
        );
        if (mounted) {
          setState(() {});
        }
        timer.cancel();
      });
    });
  }

  Future<void> getInitialLocation() async {
    initialLocation = await location.getLocation();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}
