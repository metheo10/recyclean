import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recyclean/pages/new_signal_page.dart';
import 'package:recyclean/user_drawer.dart';
import 'package:recyclean/widgets/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> myMarker = [];
  String _locationMessage = "";

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _locationMessage;
        });
      } catch (e) {
        setState(() {
          _locationMessage = 'Failed to get location: $e';
        });
      }
    }
  }

  final List<Marker> markerList = [
    Marker(
        markerId: MarkerId('first'),
        position: LatLng(33.67809150625739, 73.0143207993158),
        infoWindow: InfoWindow(
          title: "Ma position",
        ))
  ];
  late SharedPreferences preferences;
  void getUserData() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMarker.addAll(markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Center(
            child: Text(
          "RECYCLEAN",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewEvent()),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: Center(child: Text("HOME PAGE")),
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(33.67809150625739, 73.0143207993158),
      //     zoom: 12,
      //   ),
      //   // mapType: MapType.satellite,
      //   mapType: MapType.normal,
      //   markers: Set<Marker>.of(myMarker),
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
    );
  }
}
