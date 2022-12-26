import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:see_you_here_app/parties/mappers/party_mapper.dart';
import 'package:see_you_here_app/parties/mappers/person_mapper.dart';
import 'package:see_you_here_app/parties/party.dart';
import 'package:see_you_here_app/parties/person.dart';

class PartiesRepository {
  Future<Party> create(String partyNumber, LatLng target) async {
    // Crear el party
    await FirebaseFirestore.instance.collection('parties').doc(partyNumber).set(
      {
        "target": GeoPoint(target.latitude, target.longitude),
      },
    );

    return find(partyNumber);
  }

  Future<Party> find(String partyNumber) async {
    var document = await FirebaseFirestore.instance
        .collection('parties')
        .doc(partyNumber)
        .get();
    return document.toParty();
  }

  Party delete() {}

  void addPerson(Party party, Person person) {
    FirebaseFirestore.instance
        .collection('parties')
        .doc(party.id)
        .collection('people')
        .doc(person.id)
        .set(
      {
        'lat': person.position.latitude,
        'lng': person.position.longitude,
        'name': person.name,
      },
    );
  }

  void deletePerson(Party party, String personId) {
    FirebaseFirestore.instance
        .collection('parties')
        .doc(party.id)
        .collection('people')
        .doc(personId)
        .delete();
  }

  Stream<List<Person>> listenToPeopleChanges(Party party) {
    StreamController<List<Person>> streamController = StreamController();

    var subscription = FirebaseFirestore.instance
        .collection('parties')
        .doc(party.id)
        .collection('people')
        .snapshots()
        .listen((event) {
      var people = event.docs.map((e) => e.toPerson()).toList();
      streamController.sink.add(people);
    });

    streamController.onCancel = () {
      print("streamController on cancelled");
      subscription.cancel();
    };

    return streamController.stream;
  }
}
