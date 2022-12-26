import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/parties/person.dart';

extension PersonMappeer on QueryDocumentSnapshot {
  Person toPerson() {
    return Person(
      id,
      LatLng(this['lat'], this['lng']),
      this['name'],
    );
  }
}
