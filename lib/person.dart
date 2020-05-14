import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  final String id;
  final LatLng position;
  final String name;

  Person(this.id, this.position, this.name);

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      map['token'],
      LatLng(map['lat'], map['lng']),
      map['name'],
    );
  }
}
