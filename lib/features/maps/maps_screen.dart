import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

class MapsScreen extends StatefulWidget {
  final String partyNumber;
  final String userId;

  const MapsScreen({Key key, this.userId, this.partyNumber}) : super(key: key);

  static MaterialPageRoute route(String userId, String partyNumber) {
    return MaterialPageRoute(builder: (context) {
      return MapsScreen(
        userId: userId,
        partyNumber: partyNumber,
      );
    });
  }

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class Person {
  final String id;
  final LatLng position;
  final String name;
  final bool isMe;

  Person(this.id, this.position, this.name, this.isMe);
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _mapController;
  Location _location = Location();
  StreamSubscription<LocationData> subscription;
  StreamSubscription<QuerySnapshot> documentSubscription;
  List<Person> people = [];
  Set<Marker> markers = Set();
  LatLng target;

  @override
  void initState() {
    super.initState();

    _initLocation();
  }

  _initLocation() async {
    var _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("No permission");
        return;
      }
    }

    var party = await FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.partyNumber)
        .get();

    target = LatLng(
      party['target'].latitude,
      party['target'].longitude,
    );

    documentSubscription = FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.partyNumber)
        .collection('people')
        .snapshots()
        .listen((event) {
      people = event.docs
          .map(
            (e) => Person(
              e.id,
              LatLng(e['lat'], e['lng']),
              e['name'],
              e.id == widget.userId,
            ),
          )
          .toList();

      _createMarkers();
    });

    subscription = _location.onLocationChanged.listen((LocationData event) {
      if (_mapController != null) {
        double minX = people.isEmpty
            ? 0
            : people.map((e) => e.position.latitude).reduce(math.min);
        double minY = people.isEmpty
            ? 0
            : people.map((e) => e.position.longitude).reduce(math.min);
        double maxX = people.isEmpty
            ? 0
            : people.map((e) => e.position.latitude).reduce(math.max);
        double maxY = people.isEmpty
            ? 0
            : people.map((e) => e.position.longitude).reduce(math.max);

        if (target != null) {
          minX = math.min(minX, target.latitude);
          minY = math.min(minY, target.longitude);
          maxX = math.max(maxX, target.latitude);
          maxY = math.max(maxY, target.longitude);
        }

        minX = math.min(minX, event.latitude);
        minY = math.min(minY, event.longitude);
        maxX = math.max(maxX, event.latitude);
        maxY = math.max(maxY, event.longitude);

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(minX, minY),
          northeast: LatLng(maxX, maxY),
        );

        _mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            bounds,
            50,
          ),
        );
      }

      FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyNumber)
          .collection('people')
          .doc(widget.userId)
          .set({
        'lat': event.latitude,
        'lng': event.longitude,
        'name': 'RM',
      });

      print("${event.latitude}, ${event.longitude}");
    });
  }

  @override
  void didUpdateWidget(MapsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userId != widget.userId) {
      FirebaseFirestore.instance
          .collection('parties')
          .doc(widget.partyNumber)
          .collection('people')
          .doc(oldWidget.userId)
          .delete();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
    if (documentSubscription != null) {
      documentSubscription.cancel();
    }

    FirebaseFirestore.instance
        .collection('parties')
        .doc(widget.partyNumber)
        .collection('people')
        .doc(widget.userId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See you Here"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-34.5811182, -58.4375054),
          zoom: 16,
        ),
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }

  void _createMarkers() async {
    Set<Marker> newMarkers = Set();

    await Future.forEach(people, (person) async {
      var bitmapData = await _createAvatar(
        100,
        100,
        person.name,
        color: person.isMe ? Colors.red : Colors.blue,
      );
      var bitmapDescriptor = BitmapDescriptor.fromBytes(bitmapData);

      var marker = Marker(
        markerId: MarkerId(person.id),
        position: person.position,
        icon: bitmapDescriptor,
        anchor: Offset(0.5, 0.5),
      );
      newMarkers.add(marker);
    });

    if (target != null) {
      newMarkers.add(Marker(
        markerId: MarkerId("target"),
        position: target,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }

    setState(() {
      markers = newMarkers;
    });
  }

  Future<Uint8List> _createAvatar(int width, int height, String name,
      {Color color = Colors.blue}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;

    // Draw circle
    canvas.drawOval(
      Rect.fromCircle(
        center: Offset(width * 0.5, height * 0.5),
        radius: math.min(width * 0.5, height * 0.5),
      ),
      paint,
    );

    // Draw name
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: name,
      style: TextStyle(fontSize: 50.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));

    // Create image data
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data.buffer.asUint8List();
  }
}
