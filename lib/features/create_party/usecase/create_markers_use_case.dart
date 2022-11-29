import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/features/create_party/repository/target_repository.dart';

class CreateMarkersUseCase {
  final TargetRepository repository;

  CreateMarkersUseCase(this.repository);

  Set<Marker> call() {
    var markers = Set<Marker>();
    if (repository.hasData()) {
      markers.add(
        Marker(
          markerId: MarkerId("target"),
          position: repository.getTarget(),
        ),
      );
    }
    return markers;
  }
}
