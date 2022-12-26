import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/parties/party.dart';

extension PartyMapper on DocumentSnapshot {
  Party toParty() {
    return Party(
      this.id,
      LatLng(
        data()["target"].latitude,
        data()["target"].longitude,
      ),
    );
  }
}
