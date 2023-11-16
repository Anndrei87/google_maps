import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_live/src/core/helpers.dart';

class MapProvider with ChangeNotifier {
  final Completer<GoogleMapController> controller = Completer();

  List<LatLng> polylineCoordinators = [];
  LocationData? currentLocation;

  Future getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    notifyListeners();

    GoogleMapController googleMapController = await controller.future;

    location.onLocationChanged.listen((event) {
      currentLocation = event;
      notifyListeners();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16,
            target: LatLng(event.latitude!, event.longitude!),
          ),
        ),
      );
    });
  }

  Future getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      HelperMaps.googleKey,
      PointLatLng(HelperMaps.sourceLocation.latitude,
          HelperMaps.sourceLocation.longitude),
      PointLatLng(HelperMaps.destinationLocation.latitude,
          HelperMaps.destinationLocation.longitude),
    );

    if (polylineResult.points.isNotEmpty) {
      for (var element in polylineResult.points) {
        polylineCoordinators.add(LatLng(element.latitude, element.longitude));
      }
      notifyListeners();
    }
  }
}
