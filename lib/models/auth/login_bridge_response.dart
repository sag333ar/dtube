import 'dart:convert';

import 'package:dtube/models/new_videos_feed/safe_convert.dart';

class LoginBridgeResponse {
  final bool valid;
  final String accountName;
  final String key;
  final String error;

  LoginBridgeResponse({
    required this.valid,
    required this.accountName,
    required this.key,
    required this.error,
  });

  factory LoginBridgeResponse.fromJson(Map<String, dynamic>? json) =>
      LoginBridgeResponse(
        valid: asBool(json, 'valid'),
        accountName: asString(json, 'accountName'),
        key: asString(json, 'key'),
        error: asString(json, 'error'),
      );

  factory LoginBridgeResponse.fromJsonString(String jsonString) =>
      LoginBridgeResponse.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() => {
        'valid': valid,
        'accountName': accountName,
        'key': key,
        'error': error,
      };
}
