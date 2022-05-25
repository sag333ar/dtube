import 'dart:convert';

import 'package:dtube/models/new_videos_feed/safe_convert.dart';

class TransactionData {
  String? target;

  TransactionData({
    required this.target,
  });

  Map<String, dynamic> toJson() => {
        'target': target,
      };

  String toJsonString() => jsonEncode(toJson());
}

class TransactionResult {
  TransactionResultError? err;
  int? result;

  TransactionResult({
    required this.err,
    required this.result,
  });

  factory TransactionResult.fromJson(Map<String, dynamic>? json) =>
      TransactionResult(
        err: TransactionResultError.fromJson(json),
        result: asInt(json, 'result'),
      );

  factory TransactionResult.fromJsonString(String jsonString) =>
      TransactionResult.fromJson(json.decode(jsonString));
}

class TransactionResultError {
  String error;

  TransactionResultError({
    required this.error,
  });

  factory TransactionResultError.fromJson(Map<String, dynamic>? json) =>
      TransactionResultError(
        error: asString(json, 'error'),
      );

  Map<String, dynamic> toJson() => {
        'error': error,
      };
}

// [log] Result is {"err":null,"type":"transact","result":15985322}
// [log] Result is {"type":"transact","err":{"error":"invalid tx already following"}}
