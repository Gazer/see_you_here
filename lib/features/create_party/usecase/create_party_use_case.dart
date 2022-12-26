import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/features/create_party/repository/target_repository.dart';
import 'package:see_you_here_app/parties/parties_repository.dart';
import 'package:see_you_here_app/parties/party.dart';

class CreatePartyUseCase {
  final TargetRepository repository;
  final PartiesRepository partiesRepository;

  CreatePartyUseCase(this.repository, this.partiesRepository);

  Future<Party> call(String userId) async {
    var target = repository.getTarget();
    var partyNumber = _calculatePartyNumber(userId, target);

    return await partiesRepository.create(partyNumber, target);
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
