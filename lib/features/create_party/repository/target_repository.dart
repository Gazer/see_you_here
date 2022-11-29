import 'package:google_maps_flutter/google_maps_flutter.dart';

class TargetRepository {
  LatLng _target = LatLng(0, 0);

  LatLng getTarget() => _target;

  void setTarget(target) => _target = target;

  bool hasData() {
    return _target != LatLng(0, 0);
  }
}
