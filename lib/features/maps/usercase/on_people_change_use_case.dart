import 'package:see_you_here_app/parties/parties_repository.dart';
import 'package:see_you_here_app/parties/party.dart';
import 'package:see_you_here_app/parties/person.dart';

class OnPeopleChangeUseCase {
  final PartiesRepository partiesRepository;

  OnPeopleChangeUseCase(this.partiesRepository);

  Stream<List<Person>> call(Party party) {
    return partiesRepository.listenToPeopleChanges(party);
  }
}
