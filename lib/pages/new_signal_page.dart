import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recyclean/constrants/constrants.dart';
import 'package:recyclean/models/signal_model.dart';
import 'package:recyclean/network_services/post_signal.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({super.key});

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  late String imagePath = "";

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coordonneeController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final DepotController _depotController = DepotController();

  late Future<void> _initializeControllerFuture;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String imagepath = "";
  late String image1;
  late CameraController _cameraController;
  bool position = false;

  Future<void> _initCamera() async {
    _cameraController = CameraController(
      const CameraDescription(
          name: "Camera",
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 300),
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
  }

  Future<CameraDescription> _getCameraDescription(
      CameraLensDirection direction) async {
    List<CameraDescription> cameras = await availableCameras();
    return cameras.firstWhere((camera) => camera.lensDirection == direction);
  }

  String _locationMessage = "";
  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _locationMessage =
              'Latitude: ${position.latitude}, \nLongitude: ${position.longitude}';
        });
      } catch (e) {
        setState(() {
          _locationMessage = 'Failed to get location: $e';
        });
      }
    }
  }

  late Future<List<Signal>?> listSignals;

  Future<List<Signal>?> getSignals() async {
    final response = await http.post(Uri.parse("$Myurl/api/depot"));
    List<Signal> listsignal = [];
    if (response.statusCode == 200) {
      for (var signal in jsonDecode(response.body)) {
        Signal signals = Signal.fromjson(signal);
        listsignal.add(signals);
      }
      return listSignals;
    }
    return null;
  }

  void isPositioned() {
    setState(() {
      position = !position;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initCamera();
    listSignals = getSignals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "RECYCLEAN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Center(
              child: Text(
                "IMAGE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.all(8.0),
                  // height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: imagePath == ""
                      ? FormField(builder: (context) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.greenAccent,
                                  width: 4,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: TextFormField(
                              readOnly: true,
                              maxLines: 4,
                              controller: _photoController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Prendre une photo...",
                              ),
                            ),
                          );
                        })
                      : InteractiveViewer(
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.fill,
                          ),
                        )),
            ),
            Positioned(
                bottom: 0,
                top: 0,
                // right: 8,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: IconButton(
                        tooltip: "camera",
                        onPressed: () async {
                          Object? value =
                              await Navigator.pushNamed(context, '/photo');
                          setState(() {
                            imagePath = "$value";
                          });
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.white,
                        )),
                  ),
                )),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Colors.greenAccent,
              height: 10,
            ),
            const Center(
                child: Text(
              "DESCRIPTION",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.greenAccent,
                    width: 4,
                    style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: TextFormField(
                maxLines: 2,
                controller: _descriptionController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Decrire le depot\nExemple: dechets plastique, organiques..."),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Colors.greenAccent,
              height: 10,
            ),
            const Center(
                child: Text(
              "ORIENTATION",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 8.0,
            ),
            Column(
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      isPositioned();
                      if (position = true) {
                        _getCurrentLocation();
                      } else {
                        print(_coordonneeController);
                      }
                    },
                    icon: !position
                        ? Icon(
                            Icons.radio_button_checked,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.radio_button_checked,
                            color: Colors.greenAccent,
                          ),
                    label: Text("Afficher mes coordonnees GPS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 1,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(
                        color: Colors.greenAccent,
                        width: 4,
                        style: BorderStyle.solid),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: (!position)
                      ? Center(child: CircularProgressIndicator())
                      : TextFormField(
                          maxLines: 2,
                          readOnly: true,
                          controller: _coordonneeController,
                          decoration: InputDecoration(
                            hintStyle:
                                const TextStyle(color: Colors.greenAccent),
                            border: InputBorder.none,
                            hintText: _locationMessage,
                          )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final result = await _depotController.Depot(
                          image_signal: _photoController.text,
                          text_description: _descriptionController.text,
                          // long: '',
                          // lat: '',
                        );
                        if (result == 200) {
                          print("moi aussi");
                        } else {
                          print("toi aussi");
                        }
                      }
                    },
                    child: const Text(
                      "Signaler",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
