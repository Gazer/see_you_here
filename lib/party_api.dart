import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:see_you_here_app/party.dart';
import 'package:see_you_here_app/party_converter.dart';

// this is necessary for the generated code to find your class
part "party_api.chopper.dart";

@ChopperApi(baseUrl: "/")
abstract class PartyService extends ChopperService {
  // helper methods that help you instantiate your service
  static PartyService create([ChopperClient client]) => _$PartyService(client);

  @Get(path: '/parties/{id}')
  Future<Response<Party>> getParty(@Path() String id);

  @Post(path: '/parties/{id}/ping')
  Future<Response> ping(@Path() String id, @Body() Map<String, dynamic> body);

  @Post(path: '/parties')
  Future<Response<Party>> createParty(@Body() Party part);

  static PartyService getClient() {
    final chopper = ChopperClient(
      baseUrl: "http://192.168.200.13:3000",
      services: [
        // inject the generated service
        PartyService.create()
      ],
      converter: PartyConverter(),
      interceptors: [
        HttpLoggingInterceptor()
      ],
    );

    return chopper.getService<PartyService>();
  }
}
