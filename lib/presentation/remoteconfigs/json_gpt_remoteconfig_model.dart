// To parse this JSON data, do
//
//     final jsonGptRemoteConfig = jsonGptRemoteConfigFromJson(jsonString);

import 'dart:convert';

JsonGptRemoteConfig jsonGptRemoteConfigFromJson(String str) =>
    JsonGptRemoteConfig.fromJson(json.decode(str));

String jsonGptRemoteConfigToJson(JsonGptRemoteConfig data) =>
    json.encode(data.toJson());

class JsonGptRemoteConfig {
  List<String>? listOfTokens;
  String? baseUrl;
  String? modelGpt;
  List<String>? messajes;

  JsonGptRemoteConfig({
    this.listOfTokens,
    this.baseUrl,
    this.modelGpt,
    this.messajes,
  });

  factory JsonGptRemoteConfig.fromJson(Map<String, dynamic> json) =>
      JsonGptRemoteConfig(
        listOfTokens: json["listOfTokens"] == null
            ? []
            : List<String>.from(json["listOfTokens"]!.map((x) => x)),
        baseUrl: json["baseUrl"],
        modelGpt: json["modelGpt"],
        messajes: json["messajes"] == null
            ? []
            : List<String>.from(json["messajes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "listOfTokens": listOfTokens == null
            ? []
            : List<dynamic>.from(listOfTokens!.map((x) => x)),
        "baseUrl": baseUrl,
        "modelGpt": modelGpt,
        "messajes":
            messajes == null ? [] : List<dynamic>.from(messajes!.map((x) => x)),
      };
}
