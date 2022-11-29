import 'package:address_search_text_field/address_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/features/create_party/repository/target_repository.dart';
import 'package:see_you_here_app/features/create_party/usecase/create_markers_use_case.dart';
import 'package:see_you_here_app/features/create_party/usecase/create_party_use_case.dart';

import '../maps/maps_screen.dart';

class CreatePartyScreen extends StatefulWidget {
  static Route route(String userId) {
    var repository = TargetRepository();
    return MaterialPageRoute(
      builder: (_) => CreatePartyScreen(
        userId: userId,
        repository: repository,
        createMarkersUseCase: CreateMarkersUseCase(repository),
        createPartyUseCase: CreatePartyUseCase(repository),
      ),
    );
  }

  const CreatePartyScreen({
    Key key,
    this.userId,
    this.repository,
    this.createMarkersUseCase,
    this.createPartyUseCase,
  }) : super(key: key);

  final String userId;
  final TargetRepository repository;
  final CreateMarkersUseCase createMarkersUseCase;
  final CreatePartyUseCase createPartyUseCase;

  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See you Here"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 16,
              ),
              zoomGesturesEnabled: true,
              markers: widget.createMarkersUseCase(),
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
          Positioned(
            top: 8,
            left: 12,
            right: 12,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddressSearchTextField(
                  noResultsText: "No hay resultados",
                  hintText: "Lugar o direccion",
                  country: "Argentina",
                  onDone: (AddressPoint point) {
                    widget.repository.setTarget(
                      LatLng(point.latitude, point.longitude),
                    );

                    setState(() {});

                    _mapController.animateCamera(
                      CameraUpdate.newLatLng(
                        widget.repository.getTarget(),
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MapsScreen.route(
                    widget.userId,
                    await widget.createPartyUseCase(widget.userId),
                  ),
                );
              },
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
    );
  }
}
