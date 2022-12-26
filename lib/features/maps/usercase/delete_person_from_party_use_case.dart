import 'package:see_you_here_app/parties/parties_repository.dart';
import 'package:see_you_here_app/parties/party.dart';

class DeletePersonFromPartyUseCase {
  final PartiesRepository partiesRepository;

  DeletePersonFromPartyUseCase(this.partiesRepository);

  void call(Party party, String personId) {
    partiesRepository.deletePerson(party, personId);
  }
}
