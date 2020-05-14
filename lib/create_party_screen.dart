import 'package:address_search_text_field/address_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:see_you_here_app/party.dart';
import 'package:see_you_here_app/party_api.dart';
import 'package:uuid/uuid.dart';

import 'maps_screen.dart';

class CreatePartyScreen extends StatefulWidget {
  static Route route(String userId) {
    return MaterialPageRoute(
      builder: (_) => CreatePartyScreen(userId: userId),
    );
  }

  const CreatePartyScreen({Key key, this.userId}) : super(key: key);

  final String userId;

  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  GoogleMapController _mapController;
  LatLng target = LatLng(0, 0);
  Set<Marker> markers = Set();

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
              markers: markers,
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
                  noResultsText: "No se encontraron resultado",
                  hintText: "Buscá un lugar",
                  country: "Argentina",
                  onDone: (AddressPoint point) {
                    print(point.latitude);
                    print(point.longitude);

                    target = LatLng(point.latitude, point.longitude);

                    setState(() {
                      markers = Set();
                      markers.add(
                        Marker(
                          markerId: MarkerId("target"),
                          position: target,
                        ),
                      );
                    });

                    _mapController.animateCamera(
                      CameraUpdate.newLatLng(
                        target,
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
                // UserId
                var userId = widget.userId;

                // Party Number
                var partyNumber = _calculatePartyNumber(userId, target);

                print(partyNumber);

                PartyService api = PartyService.getClient();

                var party = Party(
                  target: target,
                  shortCode: partyNumber,
                );
                await api.createParty(party);

                // Abrir el mapa
                Navigator.of(context)
                    .push(MapsScreen.route(userId, partyNumber));
              },
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
    );
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
