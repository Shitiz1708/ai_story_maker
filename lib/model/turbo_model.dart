// To parse this JSON data, do
//
//     final turboMessage = turboMessageFromJson(jsonString);

import 'dart:convert';

List<TurboMessage> turboMessageFromJson(String str) => List<TurboMessage>.from(
    json.decode(str).map((x) => TurboMessage.fromJson(x)));

String turboMessageToJson(List<TurboMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TurboMessage {
  TurboMessage({
    required this.role,
    required this.content,
  });

  String role;
  String content;

  factory TurboMessage.fromJson(Map<String, dynamic> json) => TurboMessage(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}
