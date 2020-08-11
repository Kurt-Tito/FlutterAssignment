
import 'dart:async';
import 'package:HiringAssignment/constants.dart';
import 'package:HiringAssignment/services/locationservice.dart';
import 'package:HiringAssignment/services/pushnotificationservice.dart';
import 'package:HiringAssignment/usermanagement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'customwidgets/filledbutton.dart';
import 'package:flutter/scheduler.dart';

class Home extends StatefulWidget {
  final String userName;
  Home({Key key, @required this.userName}) : super(key: key);

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  // Instantiate Notification Service, Location Service, and Google Map Controller
  PushNotificationService pushNotificationService = new PushNotificationService();
  LocationService locationService = new LocationService();
  Completer<GoogleMapController> _controller = Completer();

  // Initial camera position for Google Map widget
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: Constants.ZOOM_LEVEL,
  );

  @override
  void initState() {
    super.initState();
    pushNotificationService.initialize(); // initialize push notification service for app to receive push notifications
    locationService.getCurrentLocationAndUpdateMap(_controller, () { // call location service to get current location and update map widget
        setState(() {}); // implement passed in function
      });
  }

  @override
  Widget build(BuildContext context) {
    // Calls setState after finishing the Widget build method
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
    return Scaffold(
      // Creates a top bar with text
      appBar: AppBar(title: Text("Home"),),

      /* Creates a centered column of widgets.
         Top most widget is a Text of the current user logged in.
         Middle widget is the Google Map widget.
         Bottom widget is start and destination coordinates.
         Bottom most widget is a logout button  */

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.userName),
            SizedBox(
              height: 500.0,
              child: GoogleMap( /*Google Map Widget */
                polylines: Set<Polyline>.of(locationService.polylines.values), /* places polylines on the map */
                myLocationEnabled: true, /* enables location button on map to center camera position to device location */
                mapType: MapType.normal, /* renders normal type map */
                initialCameraPosition: _kGooglePlex, /* setscamera position at _kGooglePlex */
                markers: Set<Marker>.of(locationService.markers.values), /* places markers on the map */
                zoomGesturesEnabled: true, /* enables zoom gesture*/
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller); /* Set Google Map controller for updating the map */
                },
              ),),
            SizedBox(height: 25.0,),
            Column(
              children: [
                locationService.currentLocation == null ? Text("Fetching location...") : Text("Current Location: ${locationService.currentLocation.latitude.toStringAsFixed(6)}, ${locationService.currentLocation.longitude.toStringAsFixed(6)}"),
                locationService.currentLocation == null? Text("") : Text("Destination: ${locationService.destination.latitude.toStringAsFixed(6)}, ${locationService.destination.longitude.toStringAsFixed(6)}"),
              ],
            ),
            SizedBox(height: 25.0,),
            Container(
              height:  Constants.BUTTON_HEIGHT,
              width: Constants.BUTTON_WIDTH,
              child: filledButton("LOGOUT", Colors.white, Colors.blue[100], Colors.blue[100], Colors.white, () async {
                await UserManagement.facebookLogin.logOut();
                Navigator.pop(context);
              }))
          ],
        ),
      ),
    );
  }
}