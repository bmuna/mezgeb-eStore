import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<Marker> myMarker = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(8.9806, 38.7578), zoom: 14.0),
        markers: Set.from(myMarker),
        onTap: _handleTap,
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            markerId: MarkerId(
              tappedPoint.toString(),
            ),
            position: tappedPoint,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            }),
      );
    });
  }
}
