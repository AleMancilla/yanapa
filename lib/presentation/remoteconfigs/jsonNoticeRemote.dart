// To parse this JSON data, do
//
//     final jsonNoticeRemoteSection = jsonNoticeRemoteSectionFromJson(jsonString);

import 'dart:convert';

JsonNoticeRemoteSection jsonNoticeRemoteSectionFromJson(String str) =>
    JsonNoticeRemoteSection.fromJson(json.decode(str));

String jsonNoticeRemoteSectionToJson(JsonNoticeRemoteSection data) =>
    json.encode(data.toJson());

class JsonNoticeRemoteSection {
  List<ListOfNotice>? listOfNotices;

  JsonNoticeRemoteSection({
    this.listOfNotices,
  });

  factory JsonNoticeRemoteSection.fromJson(Map<String, dynamic> json) =>
      JsonNoticeRemoteSection(
        listOfNotices: json["listOfNotices"] == null
            ? []
            : List<ListOfNotice>.from(
                json["listOfNotices"]!.map((x) => ListOfNotice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "listOfNotices": listOfNotices == null
            ? []
            : List<dynamic>.from(listOfNotices!.map((x) => x.toJson())),
      };
}

class ListOfNotice {
  String? urlPhotoOrigin;
  String? nameOrigin;
  DateTime? publicationDate;
  String? publicationTitle;
  String? publicationDescription;
  String? publicationRedTimeInMinutes;
  String? publicationImage;
  String? urlToRedirect;

  ListOfNotice({
    this.urlPhotoOrigin,
    this.nameOrigin,
    this.publicationDate,
    this.publicationTitle,
    this.publicationDescription,
    this.publicationRedTimeInMinutes,
    this.publicationImage,
    this.urlToRedirect,
  });

  factory ListOfNotice.fromJson(Map<String, dynamic> json) => ListOfNotice(
        urlPhotoOrigin: json["urlPhotoOrigin"],
        nameOrigin: json["nameOrigin"],
        publicationDate: json["publicationDate"] == null
            ? null
            : DateTime.parse(json["publicationDate"]),
        publicationTitle: json["publicationTitle"],
        publicationDescription: json["publicationDescription"],
        publicationRedTimeInMinutes: json["publicationRedTimeInMinutes"],
        publicationImage: json["publicationImage"],
        urlToRedirect: json["urlToRedirect"],
      );

  Map<String, dynamic> toJson() => {
        "urlPhotoOrigin": urlPhotoOrigin,
        "nameOrigin": nameOrigin,
        "publicationDate": publicationDate?.toIso8601String(),
        "publicationTitle": publicationTitle,
        "publicationDescription": publicationDescription,
        "publicationRedTimeInMinutes": publicationRedTimeInMinutes,
        "publicationImage": publicationImage,
        "urlToRedirect": urlToRedirect,
      };
}
