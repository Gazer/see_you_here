import 'package:see_you_here_app/parties/parties_repository.dart';
import 'package:see_you_here_app/parties/party.dart';

class GetPartyUseCase {
  final PartiesRepository partiesRepository;

  GetPartyUseCase(this.partiesRepository);

  Future<Party> call(String id) {
    return partiesRepository.find(id);
  }
}
