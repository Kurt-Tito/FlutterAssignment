import 'dart:async';
import 'dart:math';
import 'package:HiringAssignment/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/* Location Service class for handling user's
   location and updating the Map Widget */

class LocationService {

  // Initialize location data, location, latlng, bool polylinepoints and map variables
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  bool _serviceEnabled;

  LatLng start = new LatLng(38.5816, 121.4944);
  LatLng destination = new LatLng(33.921776, -118.075607);

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polyLineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};

  // Default LocationService Constructor that instantiates a new Location();
  LocationService() {
    location = new Location();
  }

  // Method that takes in a LatLng, String, and BitmapDescriptor to create a marker and adds it to map markers set.
  addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  // adds the polylines to polyline set
  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue[300], points: polyLineCoordinates);
    polylines[id] = polyline;
  }

  // method to draw the route between start and destination coordinates
  getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyB25hDWUjxzzQBBTzKb-z_AS1H2edtbqUI",
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        print(point);
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("RESULT IS EMPTY");
    }
    addPolyLine();
  }

  // returns polylines
  Map<PolylineId, Polyline> getPolylines() {
    return polylines;
  }

  // returns markers
  Map<MarkerId, Marker> getMarkers() {
    return markers;
  }

  // Method to request location permission from user
  void requestLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  /* Method that gets users current location and updates Camera position,
    draws start and destination marker, and draws polyline route on a Google Map Widget */

  void getCurrentLocationAndUpdateMap(Completer<GoogleMapController> _controller, myFunction()) async {
    requestLocationPermission();
    currentLocation = await location.getLocation();

    print("locationLatitude: ${currentLocation.latitude.toString()}");
    print("locationLongitude: ${currentLocation.longitude.toString()}");

    start = new LatLng(currentLocation.latitude, currentLocation.longitude);
    // creates a new random destination near the start coordinates
    destination = new LatLng(currentLocation.latitude + randomizeDestination(), currentLocation.longitude + randomizeDestination());

    CameraPosition newCameraPosition = CameraPosition(
      target: start,
      zoom: Constants.ZOOM_LEVEL
    );

    myFunction(); // sets state

    updateCamera(newCameraPosition, _controller);
    addMarker(start, "origin", BitmapDescriptor.defaultMarker);
    addMarker(destination, "destination", BitmapDescriptor.defaultMarker);

    getPolyline();
  }

  // Method to update camera position on Google Map Widget
  Future<void> updateCamera(CameraPosition cameraPosition, Completer<GoogleMapController> _controller) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // Method to generate a random double between 0 and 0.04
  double randomizeDestination() {
    Random random = new Random();
    double min = 0.0, max = 0.040000;
    double rng = random.nextDouble() * (max - min) + min;

    return random.nextBool() ? rng : rng * -1;
  }
}