import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/features/create_party/repository/target_repository.dart';

class CreatePartyUseCase {
  final TargetRepository repository;

  CreatePartyUseCase(this.repository);

  Future<String> call(String userId) async {
    var target = repository.getTarget();
    var partyNumber = _calculatePartyNumber(userId, target);

    // Crear el party
    await FirebaseFirestore.instance.collection('parties').doc(partyNumber).set(
      {
        "target": GeoPoint(target.latitude, target.longitude),
      },
    );

    return partyNumber;
  }

  String _calculatePartyNumber(String userId, LatLng target) {
    var tmp = "$userId;${target.latitude};${target.longitude}";
    var tmpInt = tmp.hashCode;

    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var result = '';

    while (tmpInt > 0) {
      var remainder = tmpInt % 36;
      result = chars[remainder] + result;
      tmpInt = tmpInt ~/ 36;
    }

    return result;
  }
}
