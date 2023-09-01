// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, avoid_print, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as lot;
import 'package:map_location_picker/map_location_picker.dart';

class MapPage extends StatefulWidget {
  final String artLon;
  final String artLat;
  const MapPage({Key? key, required this.artLon, required this.artLat})
      : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    getPosition();
    getCurrentLocation();
    getPolyPoints();
  }

  final Completer<GoogleMapController> _controller = Completer();

  LatLng sourceLocation = const LatLng(6.2006, 1.2003);

  LatLng destination = const LatLng(0, 0);

  Future<void> getPosition() async {
    double latitude = double.parse(widget.artLat);
    double longitude = double.parse(widget.artLon);

    destination = LatLng(latitude, longitude);

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    } else if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
    } else {
      Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (position != null) {
        double sourceLatitude = position.latitude;
        double sourceLongitude = position.longitude;

        setState(() {
          sourceLocation = LatLng(sourceLatitude, sourceLongitude);
          destination = LatLng(latitude, longitude);
          print(destination);
        });
      } else {
        print('Impossible d\'obtenir la position du client');
      }
    }
  }

  List<LatLng> polylineCoordinates = [];

  lot.LocationData? currentLocation;

  void getCurrentLocation() async {
    lot.Location location = lot.Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );

        setState(() {});
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCqaj8dP8JmwZ0Dki5mT-EvSyYr2dZBvkA',
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: Text("Chargement"),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 14.5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.orange,
                  width: 6,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId("source"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId("source"),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: const MarkerId("destination"),
                  position: destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
