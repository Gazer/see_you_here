// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$PartyService extends PartyService {
  _$PartyService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PartyService;

  @override
  Future<Response<Party>> getParty(String id) {
    final $url = '//parties/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Party, Party>($request);
  }

  @override
  Future<Response<dynamic>> ping(String id, Map<String, dynamic> body) {
    final $url = '//parties/$id/ping';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Party>> createParty(Party part) {
    final $url = '//parties';
    final $body = part;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Party, Party>($request);
  }
}
