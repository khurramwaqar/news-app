// To parse this JSON data, do
//
//     final newsPrograms = newsProgramsFromJson(jsonString);

import 'dart:convert';

NewsPrograms newsProgramsFromJson(String str) =>
    NewsPrograms.fromJson(json.decode(str));

String newsProgramsToJson(NewsPrograms data) => json.encode(data.toJson());

class NewsPrograms {
  List<Series>? series;
  String? countryCode;

  NewsPrograms({
    this.series,
    this.countryCode,
  });

  factory NewsPrograms.fromJson(Map<String, dynamic> json) => NewsPrograms(
        series: json["series"] == null
            ? []
            : List<Series>.from(json["series"]!.map((x) => Series.fromJson(x))),
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "series": series == null
            ? []
            : List<dynamic>.from(series!.map((x) => x.toJson())),
        "countryCode": countryCode,
      };
}

class Series {
  String? id;
  String? title;
  String? description;
  List<String>? cast;
  String? seriesDm;
  String? seriesYt;
  String? seiresCdn;
  String? imagePoster;
  String? imageCoverMobile;
  String? imageCoverDesktop;
  String? trailer;
  String? ost;
  String? logo;
  String? day;
  String? time;
  String? ageRatingId;
  List<String>? genreId;
  List<String>? categoryId;
  List<String>? appId;
  String? status;
  String? geoPolicy;
  AdsManager? adsManager;
  String? seriesType;
  DateTime? publishedAt;
  int? position;
  int? v;
  bool? isDm;
  String? cdnPlatform;
  String? imageCoverBig;
  String? imageCoverExtra;
  bool? isLive;
  dynamic releaseDate;
  String? seriesLayout;
  List<CategoryIdInfo>? categoryIdInfo;
  List<GeoPolicyInfo>? geoPolicyInfo;
  String? seiresCdnWebLink;
  String? seiresCdnWebKey;

  Series({
    this.id,
    this.title,
    this.description,
    this.cast,
    this.seriesDm,
    this.seriesYt,
    this.seiresCdn,
    this.imagePoster,
    this.imageCoverMobile,
    this.imageCoverDesktop,
    this.trailer,
    this.ost,
    this.logo,
    this.day,
    this.time,
    this.ageRatingId,
    this.genreId,
    this.categoryId,
    this.appId,
    this.status,
    this.geoPolicy,
    this.adsManager,
    this.seriesType,
    this.publishedAt,
    this.position,
    this.v,
    this.isDm,
    this.cdnPlatform,
    this.imageCoverBig,
    this.imageCoverExtra,
    this.isLive,
    this.releaseDate,
    this.seriesLayout,
    this.categoryIdInfo,
    this.geoPolicyInfo,
    this.seiresCdnWebLink,
    this.seiresCdnWebKey,
  });

  factory Series.fromJson(Map<String, dynamic> json) => Series(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        cast: json["cast"] == null
            ? []
            : List<String>.from(json["cast"]!.map((x) => x)),
        seriesDm: json["seriesDM"],
        seriesYt: json["seriesYT"],
        seiresCdn: json["seiresCDN"],
        imagePoster: json["imagePoster"],
        imageCoverMobile: json["imageCoverMobile"],
        imageCoverDesktop: json["imageCoverDesktop"],
        trailer: json["trailer"],
        ost: json["ost"],
        logo: json["logo"],
        day: json["day"],
        time: json["time"],
        ageRatingId: json["ageRatingId"],
        genreId: json["genreId"] == null
            ? []
            : List<String>.from(json["genreId"]!.map((x) => x)),
        categoryId: json["categoryId"] == null
            ? []
            : List<String>.from(json["categoryId"]!.map((x) => x)),
        appId: json["appId"] == null
            ? []
            : List<String>.from(json["appId"]!.map((x) => x)),
        status: json["status"],
        geoPolicy: json["geoPolicy"],
        adsManager: json["adsManager"] == null
            ? null
            : AdsManager.fromJson(json["adsManager"]),
        seriesType: json["seriesType"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        position: json["position"],
        v: json["__v"],
        isDm: json["isDM"],
        cdnPlatform: json["cdnPlatform"],
        imageCoverBig: json["imageCoverBig"],
        imageCoverExtra: json["imageCoverExtra"],
        isLive: json["isLive"],
        releaseDate: json["releaseDate"],
        seriesLayout: json["seriesLayout"],
        categoryIdInfo: json["categoryIdInfo"] == null
            ? []
            : List<CategoryIdInfo>.from(
                json["categoryIdInfo"]!.map((x) => CategoryIdInfo.fromJson(x))),
        geoPolicyInfo: json["geoPolicyInfo"] == null
            ? []
            : List<GeoPolicyInfo>.from(
                json["geoPolicyInfo"]!.map((x) => GeoPolicyInfo.fromJson(x))),
        seiresCdnWebLink: json["seiresCDNWebLink"],
        seiresCdnWebKey: json["seiresCDNWebKey"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "cast": cast == null ? [] : List<dynamic>.from(cast!.map((x) => x)),
        "seriesDM": seriesDm,
        "seriesYT": seriesYt,
        "seiresCDN": seiresCdn,
        "imagePoster": imagePoster,
        "imageCoverMobile": imageCoverMobile,
        "imageCoverDesktop": imageCoverDesktop,
        "trailer": trailer,
        "ost": ost,
        "logo": logo,
        "day": day,
        "time": time,
        "ageRatingId": ageRatingId,
        "genreId":
            genreId == null ? [] : List<dynamic>.from(genreId!.map((x) => x)),
        "categoryId": categoryId == null
            ? []
            : List<dynamic>.from(categoryId!.map((x) => x)),
        "appId": appId == null ? [] : List<dynamic>.from(appId!.map((x) => x)),
        "status": status,
        "geoPolicy": geoPolicy,
        "adsManager": adsManager?.toJson(),
        "seriesType": seriesType,
        "publishedAt": publishedAt?.toIso8601String(),
        "position": position,
        "__v": v,
        "isDM": isDm,
        "cdnPlatform": cdnPlatform,
        "imageCoverBig": imageCoverBig,
        "imageCoverExtra": imageCoverExtra,
        "isLive": isLive,
        "releaseDate": releaseDate,
        "seriesLayout": seriesLayout,
        "categoryIdInfo": categoryIdInfo == null
            ? []
            : List<dynamic>.from(categoryIdInfo!.map((x) => x.toJson())),
        "geoPolicyInfo": geoPolicyInfo == null
            ? []
            : List<dynamic>.from(geoPolicyInfo!.map((x) => x.toJson())),
        "seiresCDNWebLink": seiresCdnWebLink,
        "seiresCDNWebKey": seiresCdnWebKey,
      };
}

class AdsManager {
  String? id;
  String? title;
  String? type;
  String? tag;
  int? v;

  AdsManager({
    this.id,
    this.title,
    this.type,
    this.tag,
    this.v,
  });

  factory AdsManager.fromJson(Map<String, dynamic> json) => AdsManager(
        id: json["_id"],
        title: json["title"],
        type: json["type"],
        tag: json["tag"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "type": type,
        "tag": tag,
        "__v": v,
      };
}

class CategoryIdInfo {
  String? id;
  String? title;
  String? description;
  String? image;
  String? appId;
  int? v;
  bool? published;

  CategoryIdInfo({
    this.id,
    this.title,
    this.description,
    this.image,
    this.appId,
    this.v,
    this.published,
  });

  factory CategoryIdInfo.fromJson(Map<String, dynamic> json) => CategoryIdInfo(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        appId: json["appId"],
        v: json["__v"],
        published: json["published"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image,
        "appId": appId,
        "__v": v,
        "published": published,
      };
}

class GeoPolicyInfo {
  String? id;
  String? title;
  String? condition;
  List<String>? countries;
  int? v;

  GeoPolicyInfo({
    this.id,
    this.title,
    this.condition,
    this.countries,
    this.v,
  });

  factory GeoPolicyInfo.fromJson(Map<String, dynamic> json) => GeoPolicyInfo(
        id: json["_id"],
        title: json["title"],
        condition: json["condition"],
        countries: json["countries"] == null
            ? []
            : List<String>.from(json["countries"]!.map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "condition": condition,
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x)),
        "__v": v,
      };
}
