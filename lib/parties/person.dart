import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  final String id;
  final LatLng position;
  final String name;

  Person(this.id, this.position, this.name);
}
