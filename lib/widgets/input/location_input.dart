import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationInputScreen extends StatefulWidget {
  final LatLong? initPosition;

  const LocationInputScreen({
    this.initPosition,
    Key? key
  }) : super(key: key);

  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Input'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FlutterLocationPicker(
          initPosition: widget.initPosition,
          onPicked: (pickedData) {
          },
        ),
      ),
    );
  }
}