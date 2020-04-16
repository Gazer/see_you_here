import 'package:flutter/material.dart';
import 'package:see_you_here_app/maps_screen.dart';
import 'package:uuid/uuid.dart';

class JoinScreen extends StatefulWidget {
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  TextEditingController partyNumberController;

  @override
  void initState() {
    super.initState();
    partyNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    partyNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See you Here"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: partyNumberController,
            decoration: InputDecoration(
              hintText: "Party Number",
            ),
          ),
          RaisedButton(
            child: Text("Go!"),
            onPressed: () {
              Navigator.of(context).push(
                MapsScreen.route(Uuid().v1(), partyNumberController.text)
              );
            },
          )
        ],
      ),
    );
  }
}
