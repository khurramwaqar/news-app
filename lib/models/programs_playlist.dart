// To parse this JSON data, do
//
//     final programsPlaylistModel = programsPlaylistModelFromJson(jsonString);

import 'dart:convert';

ProgramsPlaylistModel programsPlaylistModelFromJson(String str) =>
    ProgramsPlaylistModel.fromJson(json.decode(str));

String programsPlaylistModelToJson(ProgramsPlaylistModel data) =>
    json.encode(data.toJson());

class ProgramsPlaylistModel {
  List<Episode>? episode;

  ProgramsPlaylistModel({
    this.episode,
  });

  factory ProgramsPlaylistModel.fromJson(Map<String, dynamic> json) =>
      ProgramsPlaylistModel(
        episode: json["episode"] == null
            ? []
            : List<Episode>.from(
                json["episode"]!.map((x) => Episode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "episode": episode == null
            ? []
            : List<dynamic>.from(episode!.map((x) => x.toJson())),
      };
}

class Episode {
  String? id;
  String? seriesId;
  dynamic videoSource;
  String? title;
  String? description;
  String? imagePath;
  String? videoYtId;
  dynamic videoViews;
  dynamic videoLength;
  DateTime? createdAd;
  int? v;

  Episode({
    this.id,
    this.seriesId,
    this.videoSource,
    this.title,
    this.description,
    this.imagePath,
    this.videoYtId,
    this.videoViews,
    this.videoLength,
    this.createdAd,
    this.v,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["_id"],
        seriesId: json["seriesId"],
        videoSource: json["videoSource"],
        title: json["title"],
        description: json["description"],
        imagePath: json["imagePath"],
        videoYtId: json["videoYtId"],
        videoViews: json["videoViews"],
        videoLength: json["videoLength"],
        createdAd: json["createdAd"] == null
            ? null
            : DateTime.parse(json["createdAd"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "seriesId": seriesId,
        "videoSource": videoSource,
        "title": title,
        "description": description,
        "imagePath": imagePath,
        "videoYtId": videoYtId,
        "videoViews": videoViews,
        "videoLength": videoLength,
        "createdAd": createdAd?.toIso8601String(),
        "__v": v,
      };
}
