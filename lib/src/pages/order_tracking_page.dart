import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_live/src/core/helpers.dart';
import 'package:maps_live/src/providers/maps_controller.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await context.read<MapProvider>().getCurrentLocation();
      await context.read<MapProvider>().getPolyPoints();
    });
  }

  Future teste = Future.delayed(Duration(seconds: 2)).then((value) {});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (_, provider, __) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Track order',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: provider.currentLocation == null
            ? const Center(
                child: Text('Loading'),
              )
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      provider.currentLocation!.latitude!,
                      provider.currentLocation!.longitude!,
                    ),
                    zoom: 16),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('polyLineId'),
                    points: provider.polylineCoordinators,
                    color: HelperMaps.primaryColor,
                    width: 6,
                  )
                },
                markers: {
                  const Marker(
                    markerId: MarkerId("source"),
                    position: HelperMaps.sourceLocation,
                  ),
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(provider.currentLocation!.latitude!,
                        provider.currentLocation!.longitude!),
                  ),
                  const Marker(
                    markerId: MarkerId("destination"),
                    position: HelperMaps.destinationLocation,
                  )
                },
                onMapCreated: (mapController) {
                  provider.controller.complete(mapController);
                },
              ),
      );
    });
  }
}
