import 'package:see_you_here_app/parties/parties_repository.dart';
import 'package:see_you_here_app/parties/party.dart';
import 'package:see_you_here_app/parties/person.dart';

class AddPersonToPartyUseCase {
  final PartiesRepository partiesRepository;

  AddPersonToPartyUseCase(this.partiesRepository);

  Future<void> call(Party party, Person person) async {
    partiesRepository.addPerson(party, person);
  }
}
