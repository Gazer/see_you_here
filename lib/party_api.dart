import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// this is necessary for the generated code to find your class
part "party_api.chopper.dart";

@ChopperApi(baseUrl: "/")
abstract class PartyService extends ChopperService {
  // helper methods that help you instantiate your service
  static PartyService create([ChopperClient client]) => _$PartyService(client);

  @Get(path: '/parties/{id}')
  Future<Response> getParty(@Path() String id);

  @Post(path: '/parties/{id}/ping')
  Future<Response> ping(@Path() String id, @Body() Map<String, dynamic> body);

  @Post(path: '/parties')
  Future<Response> createParty(@Body() Map<String, dynamic> body);

  static PartyService getClient() {
    final chopper = ChopperClient(
      baseUrl: "http://192.168.200.13:3000",
      services: [
        // inject the generated service
        PartyService.create()
      ],
      converter: JsonConverter(),
    );

    return chopper.getService<PartyService>();
  }
}
