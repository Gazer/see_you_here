import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/person.dart';

class Party {
  final LatLng target;
  final String shortCode;
  final List<Person> people;

  Party({this.target, this.shortCode, this.people});

  factory Party.fromMap(Map<String, dynamic> map) {
    List<Person> people = [];

    if (map['people'] is List) {
      people = map['people'].map<Person>((map) => Person.fromMap(map)).toList();
    }

    return Party(
      target: LatLng(map['latitud'], map['longitud']),
      shortCode: map['short_code'],
      people: people,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitud': target.latitude,
      'longitud': target.longitude,
      "short_code": shortCode,
    };
  }
}