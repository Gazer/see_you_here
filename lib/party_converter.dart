import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:see_you_here_app/party.dart';

class PartyConverter extends JsonConverter {

  @override
  Request convertRequest(Request request) {
    // Party -> Map -> String
    Request req = request;
    if (req.body is Party) {
      Party party = req.body;
      req = req.copyWith(body: party.toMap());
    }

    return super.convertRequest(req);
  }

  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType>(Response response) {
    final Response res = super.convertResponse(response);

    final BodyType newBody = _convert<SingleItemType>(res.body);

    return response.copyWith(body: newBody);
  }

  dynamic _convert<SingleItemType>(dynamic element) {
    if (element is Party) return element;

    if (element is List) {
      List<Map<String, dynamic>> jsonMap = element;
      return jsonMap.map((e) => Party.fromMap(e)).toList();
    } else {
      var map = element as Map<String, dynamic>;
      if (map.containsKey('latitud')) {
        return Party.fromMap(map);
      } else {
        return element;
      }
    }
  }
}
