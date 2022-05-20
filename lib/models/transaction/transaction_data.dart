import 'dart:convert';

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
