// To parse this JSON data, do
//
//     final adsManager = adsManagerFromJson(jsonString);

import 'dart:convert';

AdsManagerModel adsManagerFromJson(String str) =>
    AdsManagerModel.fromJson(json.decode(str));

String adsManagerToJson(AdsManagerModel data) => json.encode(data.toJson());

class AdsManagerModel {
  IosMeta? iosMeta;

  AdsManagerModel({
    this.iosMeta,
  });

  factory AdsManagerModel.fromJson(Map<String, dynamic> json) =>
      AdsManagerModel(
        iosMeta:
            json["IOSMeta"] == null ? null : IosMeta.fromJson(json["IOSMeta"]),
      );

  Map<String, dynamic> toJson() => {
        "IOSMeta": iosMeta?.toJson(),
      };
}

class IosMeta {
  bool? ioshomeTopStatus;
  String? ioshomeTopAdType;
  String? ioshomeTopAdUnit;
  String? ioshomeTopAdsize;
  bool? ioshomeFirstStatus;
  String? ioshomeFirstAdType;
  String? ioshomeFirstAdUnit;
  String? ioshomeFirstAdsize;
  bool? ioshomeSecondStatus;
  String? ioshomeSecondAdType;
  String? ioshomeSecondAdUnit;
  String? ioshomeSecondAdsize;
  bool? ioshomeCatfishStatus;
  String? ioshomeCatfishAdType;
  String? ioshomeCatfishAdUnit;
  String? ioshomeCatfishAdsize;
  bool? iosSingleTopStatus;
  String? iosSingleTopAdType;
  String? iosSingleTopAdUnit;
  String? iosSingleTopAdsize;
  bool? iosSingleFirstStatus;
  String? iosSingleFirstAdType;
  String? iosSingleFirstAdUnit;
  String? iosSingleFirstAdsize;
  bool? iosSingleSecondStatus;
  String? iosSingleSecondAdType;
  String? iosSingleSecondAdUnit;
  String? iosSingleSecondAdsize;
  bool? iosSingleCatfishStatus;
  String? iosSingleCatfishAdType;
  String? iosSingleCatfishAdUnit;
  String? iosSingleCatfishAdsize;
  bool? iosCategoryTopStatus;
  String? iosCategoryTopAdType;
  String? iosCategoryTopAdUnit;
  String? iosCategoryTopAdsize;
  bool? iosCategoryFirstStatus = false;
  String? iosCategoryFirstAdType;
  String? iosCategoryFirstAdUnit;
  String? iosCategoryFirstAdsize;
  bool? iosCategorySecondStatus;
  String? iosCategorySecondAdType;
  String? iosCategorySecondAdUnit;
  String? iosCategorySecondAdsize;
  bool? iosCategoryCatfishStatus;
  String? iosCategoryCatfishAdType;
  String? iosCategoryCatfishAdUnit;
  String? iosCategoryCatfishAdsize;
  bool? iosProgramsCategoryTopStatus;
  String? iosProgramsCategoryTopAdType;
  String? iosProgramsCategoryTopAdUnit;
  String? iosProgramsCategoryTopAdsize;
  bool? iosProgramsCategoryFirstStatus;
  String? iosProgramsCategoryFirstAdType;
  String? iosProgramsCategoryFirstAdUnit;
  String? iosProgramsCategoryFirstAdsize;
  bool? iosProgramsCategorySecondStatus;
  String? iosProgramsCategorySecondAdType;
  String? iosProgramsCategorySecondAdUnit;
  String? iosProgramsCategorySecondAdsize;
  bool? iosProgramsCategoryCatfishStatus;
  String? iosProgramsCategoryCatfishAdType;
  String? iosProgramsCategoryCatfishAdUnit;
  String? iosProgramsCategoryCatfishAdsize;
  bool? iosProgramsSingleTopStatus;
  String? iosProgramsSingleTopAdType;
  String? iosProgramsSingleTopAdUnit;
  String? iosProgramsSingleTopAdsize;
  bool? iosProgramsSingleFirstStatus;
  String? iosProgramsSingleFirstAdType;
  String? iosProgramsSingleFirstAdUnit;
  String? iosProgramsSingleFirstAdsize;
  bool? iosProgramsSingleSecondStatus;
  String? iosProgramsSingleSecondAdType;
  String? iosProgramsSingleSecondAdUnit;
  String? iosProgramsSingleSecondAdsize;
  bool? iosProgramsSingleCatfishStatus;
  String? iosProgramsSingleCatfishAdType;
  String? iosProgramsSingleCatfishAdUnit;
  String? iosProgramsSingleCatfishAdsize;
  bool? iosLiveTopStatus;
  String? iosLiveTopAdType;
  String? iosLiveTopAdUnit;
  String? iosLiveTopAdsize;
  bool? iosLiveFirstStatus;
  String? iosLiveFirstAdType;
  String? iosLiveFirstAdUnit;
  String? iosLiveFirstAdsize;
  bool? iosLiveSecondStatus;
  String? iosLiveSecondAdType;
  String? iosLiveSecondAdUnit;
  String? iosLiveSecondAdsize;
  bool? iosLiveCatfishStatus;
  String? iosLiveCatfishAdType;
  String? iosLiveCatfishAdUnit;
  String? iosLiveCatfishAdsize;
  bool? iosAudioLiveTopStatus;
  String? iosAudioLiveTopAdType;
  String? iosAudioLiveTopAdUnit;
  String? iosAudioLiveTopAdsize;
  bool? iosAudioLiveFirstStatus;
  String? iosAudioLiveFirstAdType;
  String? iosAudioLiveFirstAdUnit;
  String? iosAudioLiveFirstAdsize;
  bool? iosAudioLiveSecondStatus;
  String? iosAudioLiveSecondAdType;
  String? iosAudioLiveSecondAdUnit;
  String? iosAudioLiveSecondAdsize;
  bool? iosAudioLiveCatfishStatus;
  String? iosAudioLiveCatfishAdType;
  String? iosAudioLiveCatfishAdUnit;
  String? iosAudioLiveCatfishAdsize;
  String? iosLiveStreamStream;
  String? iosLiveStreamAdUrl;

  IosMeta({
    this.ioshomeTopStatus,
    this.ioshomeTopAdType,
    this.ioshomeTopAdUnit,
    this.ioshomeTopAdsize,
    this.ioshomeFirstStatus,
    this.ioshomeFirstAdType,
    this.ioshomeFirstAdUnit,
    this.ioshomeFirstAdsize,
    this.ioshomeSecondStatus,
    this.ioshomeSecondAdType,
    this.ioshomeSecondAdUnit,
    this.ioshomeSecondAdsize,
    this.ioshomeCatfishStatus,
    this.ioshomeCatfishAdType,
    this.ioshomeCatfishAdUnit,
    this.ioshomeCatfishAdsize,
    this.iosSingleTopStatus,
    this.iosSingleTopAdType,
    this.iosSingleTopAdUnit,
    this.iosSingleTopAdsize,
    this.iosSingleFirstStatus,
    this.iosSingleFirstAdType,
    this.iosSingleFirstAdUnit,
    this.iosSingleFirstAdsize,
    this.iosSingleSecondStatus,
    this.iosSingleSecondAdType,
    this.iosSingleSecondAdUnit,
    this.iosSingleSecondAdsize,
    this.iosSingleCatfishStatus,
    this.iosSingleCatfishAdType,
    this.iosSingleCatfishAdUnit,
    this.iosSingleCatfishAdsize,
    this.iosCategoryTopStatus,
    this.iosCategoryTopAdType,
    this.iosCategoryTopAdUnit,
    this.iosCategoryTopAdsize,
    this.iosCategoryFirstStatus,
    this.iosCategoryFirstAdType,
    this.iosCategoryFirstAdUnit,
    this.iosCategoryFirstAdsize,
    this.iosCategorySecondStatus,
    this.iosCategorySecondAdType,
    this.iosCategorySecondAdUnit,
    this.iosCategorySecondAdsize,
    this.iosCategoryCatfishStatus,
    this.iosCategoryCatfishAdType,
    this.iosCategoryCatfishAdUnit,
    this.iosCategoryCatfishAdsize,
    this.iosProgramsCategoryTopStatus,
    this.iosProgramsCategoryTopAdType,
    this.iosProgramsCategoryTopAdUnit,
    this.iosProgramsCategoryTopAdsize,
    this.iosProgramsCategoryFirstStatus,
    this.iosProgramsCategoryFirstAdType,
    this.iosProgramsCategoryFirstAdUnit,
    this.iosProgramsCategoryFirstAdsize,
    this.iosProgramsCategorySecondStatus,
    this.iosProgramsCategorySecondAdType,
    this.iosProgramsCategorySecondAdUnit,
    this.iosProgramsCategorySecondAdsize,
    this.iosProgramsCategoryCatfishStatus,
    this.iosProgramsCategoryCatfishAdType,
    this.iosProgramsCategoryCatfishAdUnit,
    this.iosProgramsCategoryCatfishAdsize,
    this.iosProgramsSingleTopStatus,
    this.iosProgramsSingleTopAdType,
    this.iosProgramsSingleTopAdUnit,
    this.iosProgramsSingleTopAdsize,
    this.iosProgramsSingleFirstStatus,
    this.iosProgramsSingleFirstAdType,
    this.iosProgramsSingleFirstAdUnit,
    this.iosProgramsSingleFirstAdsize,
    this.iosProgramsSingleSecondStatus,
    this.iosProgramsSingleSecondAdType,
    this.iosProgramsSingleSecondAdUnit,
    this.iosProgramsSingleSecondAdsize,
    this.iosProgramsSingleCatfishStatus,
    this.iosProgramsSingleCatfishAdType,
    this.iosProgramsSingleCatfishAdUnit,
    this.iosProgramsSingleCatfishAdsize,
    this.iosLiveTopStatus,
    this.iosLiveTopAdType,
    this.iosLiveTopAdUnit,
    this.iosLiveTopAdsize,
    this.iosLiveFirstStatus,
    this.iosLiveFirstAdType,
    this.iosLiveFirstAdUnit,
    this.iosLiveFirstAdsize,
    this.iosLiveSecondStatus,
    this.iosLiveSecondAdType,
    this.iosLiveSecondAdUnit,
    this.iosLiveSecondAdsize,
    this.iosLiveCatfishStatus,
    this.iosLiveCatfishAdType,
    this.iosLiveCatfishAdUnit,
    this.iosLiveCatfishAdsize,
    this.iosAudioLiveTopStatus,
    this.iosAudioLiveTopAdType,
    this.iosAudioLiveTopAdUnit,
    this.iosAudioLiveTopAdsize,
    this.iosAudioLiveFirstStatus,
    this.iosAudioLiveFirstAdType,
    this.iosAudioLiveFirstAdUnit,
    this.iosAudioLiveFirstAdsize,
    this.iosAudioLiveSecondStatus,
    this.iosAudioLiveSecondAdType,
    this.iosAudioLiveSecondAdUnit,
    this.iosAudioLiveSecondAdsize,
    this.iosAudioLiveCatfishStatus,
    this.iosAudioLiveCatfishAdType,
    this.iosAudioLiveCatfishAdUnit,
    this.iosAudioLiveCatfishAdsize,
    this.iosLiveStreamStream,
    this.iosLiveStreamAdUrl,
  });

  factory IosMeta.fromJson(Map<String, dynamic> json) => IosMeta(
        ioshomeTopStatus: json["IOSHOMETopStatus"],
        ioshomeTopAdType: json["IOSHOMETopAdType"],
        ioshomeTopAdUnit: json["IOSHOMETopAdUnit"],
        ioshomeTopAdsize: json["IOSHOMETopAdsize"],
        ioshomeFirstStatus: json["IOSHOMEFirstStatus"],
        ioshomeFirstAdType: json["IOSHOMEFirstAdType"],
        ioshomeFirstAdUnit: json["IOSHOMEFirstAdUnit"],
        ioshomeFirstAdsize: json["IOSHOMEFirstAdsize"],
        ioshomeSecondStatus: json["IOSHOMESecondStatus"],
        ioshomeSecondAdType: json["IOSHOMESecondAdType"],
        ioshomeSecondAdUnit: json["IOSHOMESecondAdUnit"],
        ioshomeSecondAdsize: json["IOSHOMESecondAdsize"],
        ioshomeCatfishStatus: json["IOSHOMECatfishStatus"],
        ioshomeCatfishAdType: json["IOSHOMECatfishAdType"],
        ioshomeCatfishAdUnit: json["IOSHOMECatfishAdUnit"],
        ioshomeCatfishAdsize: json["IOSHOMECatfishAdsize"],
        iosSingleTopStatus: json["IOSSingleTopStatus"],
        iosSingleTopAdType: json["IOSSingleTopAdType"],
        iosSingleTopAdUnit: json["IOSSingleTopAdUnit"],
        iosSingleTopAdsize: json["IOSSingleTopAdsize"],
        iosSingleFirstStatus: json["IOSSingleFirstStatus"],
        iosSingleFirstAdType: json["IOSSingleFirstAdType"],
        iosSingleFirstAdUnit: json["IOSSingleFirstAdUnit"],
        iosSingleFirstAdsize: json["IOSSingleFirstAdsize"],
        iosSingleSecondStatus: json["IOSSingleSecondStatus"],
        iosSingleSecondAdType: json["IOSSingleSecondAdType"],
        iosSingleSecondAdUnit: json["IOSSingleSecondAdUnit"],
        iosSingleSecondAdsize: json["IOSSingleSecondAdsize"],
        iosSingleCatfishStatus: json["IOSSingleCatfishStatus"],
        iosSingleCatfishAdType: json["IOSSingleCatfishAdType"],
        iosSingleCatfishAdUnit: json["IOSSingleCatfishAdUnit"],
        iosSingleCatfishAdsize: json["IOSSingleCatfishAdsize"],
        iosCategoryTopStatus: json["IOSCategoryTopStatus"],
        iosCategoryTopAdType: json["IOSCategoryTopAdType"],
        iosCategoryTopAdUnit: json["IOSCategoryTopAdUnit"],
        iosCategoryTopAdsize: json["IOSCategoryTopAdsize"],
        iosCategoryFirstStatus: json["IOSCategoryFirstStatus"],
        iosCategoryFirstAdType: json["IOSCategoryFirstAdType"],
        iosCategoryFirstAdUnit: json["IOSCategoryFirstAdUnit"],
        iosCategoryFirstAdsize: json["IOSCategoryFirstAdsize"],
        iosCategorySecondStatus: json["IOSCategorySecondStatus"],
        iosCategorySecondAdType: json["IOSCategorySecondAdType"],
        iosCategorySecondAdUnit: json["IOSCategorySecondAdUnit"],
        iosCategorySecondAdsize: json["IOSCategorySecondAdsize"],
        iosCategoryCatfishStatus: json["IOSCategoryCatfishStatus"],
        iosCategoryCatfishAdType: json["IOSCategoryCatfishAdType"],
        iosCategoryCatfishAdUnit: json["IOSCategoryCatfishAdUnit"],
        iosCategoryCatfishAdsize: json["IOSCategoryCatfishAdsize"],
        iosProgramsCategoryTopStatus: json["IOSProgramsCategoryTopStatus"],
        iosProgramsCategoryTopAdType: json["IOSProgramsCategoryTopAdType"],
        iosProgramsCategoryTopAdUnit: json["IOSProgramsCategoryTopAdUnit"],
        iosProgramsCategoryTopAdsize: json["IOSProgramsCategoryTopAdsize"],
        iosProgramsCategoryFirstStatus: json["IOSProgramsCategoryFirstStatus"],
        iosProgramsCategoryFirstAdType: json["IOSProgramsCategoryFirstAdType"],
        iosProgramsCategoryFirstAdUnit: json["IOSProgramsCategoryFirstAdUnit"],
        iosProgramsCategoryFirstAdsize: json["IOSProgramsCategoryFirstAdsize"],
        iosProgramsCategorySecondStatus:
            json["IOSProgramsCategorySecondStatus"],
        iosProgramsCategorySecondAdType:
            json["IOSProgramsCategorySecondAdType"],
        iosProgramsCategorySecondAdUnit:
            json["IOSProgramsCategorySecondAdUnit"],
        iosProgramsCategorySecondAdsize:
            json["IOSProgramsCategorySecondAdsize"],
        iosProgramsCategoryCatfishStatus:
            json["IOSProgramsCategoryCatfishStatus"],
        iosProgramsCategoryCatfishAdType:
            json["IOSProgramsCategoryCatfishAdType"],
        iosProgramsCategoryCatfishAdUnit:
            json["IOSProgramsCategoryCatfishAdUnit"],
        iosProgramsCategoryCatfishAdsize:
            json["IOSProgramsCategoryCatfishAdsize"],
        iosProgramsSingleTopStatus: json["IOSProgramsSingleTopStatus"],
        iosProgramsSingleTopAdType: json["IOSProgramsSingleTopAdType"],
        iosProgramsSingleTopAdUnit: json["IOSProgramsSingleTopAdUnit"],
        iosProgramsSingleTopAdsize: json["IOSProgramsSingleTopAdsize"],
        iosProgramsSingleFirstStatus: json["IOSProgramsSingleFirstStatus"],
        iosProgramsSingleFirstAdType: json["IOSProgramsSingleFirstAdType"],
        iosProgramsSingleFirstAdUnit: json["IOSProgramsSingleFirstAdUnit"],
        iosProgramsSingleFirstAdsize: json["IOSProgramsSingleFirstAdsize"],
        iosProgramsSingleSecondStatus: json["IOSProgramsSingleSecondStatus"],
        iosProgramsSingleSecondAdType: json["IOSProgramsSingleSecondAdType"],
        iosProgramsSingleSecondAdUnit: json["IOSProgramsSingleSecondAdUnit"],
        iosProgramsSingleSecondAdsize: json["IOSProgramsSingleSecondAdsize"],
        iosProgramsSingleCatfishStatus: json["IOSProgramsSingleCatfishStatus"],
        iosProgramsSingleCatfishAdType: json["IOSProgramsSingleCatfishAdType"],
        iosProgramsSingleCatfishAdUnit: json["IOSProgramsSingleCatfishAdUnit"],
        iosProgramsSingleCatfishAdsize: json["IOSProgramsSingleCatfishAdsize"],
        iosLiveTopStatus: json["IOSLiveTopStatus"],
        iosLiveTopAdType: json["IOSLiveTopAdType"],
        iosLiveTopAdUnit: json["IOSLiveTopAdUnit"],
        iosLiveTopAdsize: json["IOSLiveTopAdsize"],
        iosLiveFirstStatus: json["IOSLiveFirstStatus"],
        iosLiveFirstAdType: json["IOSLiveFirstAdType"],
        iosLiveFirstAdUnit: json["IOSLiveFirstAdUnit"],
        iosLiveFirstAdsize: json["IOSLiveFirstAdsize"],
        iosLiveSecondStatus: json["IOSLiveSecondStatus"],
        iosLiveSecondAdType: json["IOSLiveSecondAdType"],
        iosLiveSecondAdUnit: json["IOSLiveSecondAdUnit"],
        iosLiveSecondAdsize: json["IOSLiveSecondAdsize"],
        iosLiveCatfishStatus: json["IOSLiveCatfishStatus"],
        iosLiveCatfishAdType: json["IOSLiveCatfishAdType"],
        iosLiveCatfishAdUnit: json["IOSLiveCatfishAdUnit"],
        iosLiveCatfishAdsize: json["IOSLiveCatfishAdsize"],
        iosAudioLiveTopStatus: json["IOSAudioLiveTopStatus"],
        iosAudioLiveTopAdType: json["IOSAudioLiveTopAdType"],
        iosAudioLiveTopAdUnit: json["IOSAudioLiveTopAdUnit"],
        iosAudioLiveTopAdsize: json["IOSAudioLiveTopAdsize"],
        iosAudioLiveFirstStatus: json["IOSAudioLiveFirstStatus"],
        iosAudioLiveFirstAdType: json["IOSAudioLiveFirstAdType"],
        iosAudioLiveFirstAdUnit: json["IOSAudioLiveFirstAdUnit"],
        iosAudioLiveFirstAdsize: json["IOSAudioLiveFirstAdsize"],
        iosAudioLiveSecondStatus: json["IOSAudioLiveSecondStatus"],
        iosAudioLiveSecondAdType: json["IOSAudioLiveSecondAdType"],
        iosAudioLiveSecondAdUnit: json["IOSAudioLiveSecondAdUnit"],
        iosAudioLiveSecondAdsize: json["IOSAudioLiveSecondAdsize"],
        iosAudioLiveCatfishStatus: json["IOSAudioLiveCatfishStatus"],
        iosAudioLiveCatfishAdType: json["IOSAudioLiveCatfishAdType"],
        iosAudioLiveCatfishAdUnit: json["IOSAudioLiveCatfishAdUnit"],
        iosAudioLiveCatfishAdsize: json["IOSAudioLiveCatfishAdsize"],
        iosLiveStreamStream: json["IOSLiveStreamStream"],
        iosLiveStreamAdUrl: json["IOSLiveStreamAdUrl"],
      );

  Map<String, dynamic> toJson() => {
        "IOSHOMETopStatus": ioshomeTopStatus,
        "IOSHOMETopAdType": ioshomeTopAdType,
        "IOSHOMETopAdUnit": ioshomeTopAdUnit,
        "IOSHOMETopAdsize": ioshomeTopAdsize,
        "IOSHOMEFirstStatus": ioshomeFirstStatus,
        "IOSHOMEFirstAdType": ioshomeFirstAdType,
        "IOSHOMEFirstAdUnit": ioshomeFirstAdUnit,
        "IOSHOMEFirstAdsize": ioshomeFirstAdsize,
        "IOSHOMESecondStatus": ioshomeSecondStatus,
        "IOSHOMESecondAdType": ioshomeSecondAdType,
        "IOSHOMESecondAdUnit": ioshomeSecondAdUnit,
        "IOSHOMESecondAdsize": ioshomeSecondAdsize,
        "IOSHOMECatfishStatus": ioshomeCatfishStatus,
        "IOSHOMECatfishAdType": ioshomeCatfishAdType,
        "IOSHOMECatfishAdUnit": ioshomeCatfishAdUnit,
        "IOSHOMECatfishAdsize": ioshomeCatfishAdsize,
        "IOSSingleTopStatus": iosSingleTopStatus,
        "IOSSingleTopAdType": iosSingleTopAdType,
        "IOSSingleTopAdUnit": iosSingleTopAdUnit,
        "IOSSingleTopAdsize": iosSingleTopAdsize,
        "IOSSingleFirstStatus": iosSingleFirstStatus,
        "IOSSingleFirstAdType": iosSingleFirstAdType,
        "IOSSingleFirstAdUnit": iosSingleFirstAdUnit,
        "IOSSingleFirstAdsize": iosSingleFirstAdsize,
        "IOSSingleSecondStatus": iosSingleSecondStatus,
        "IOSSingleSecondAdType": iosSingleSecondAdType,
        "IOSSingleSecondAdUnit": iosSingleSecondAdUnit,
        "IOSSingleSecondAdsize": iosSingleSecondAdsize,
        "IOSSingleCatfishStatus": iosSingleCatfishStatus,
        "IOSSingleCatfishAdType": iosSingleCatfishAdType,
        "IOSSingleCatfishAdUnit": iosSingleCatfishAdUnit,
        "IOSSingleCatfishAdsize": iosSingleCatfishAdsize,
        "IOSCategoryTopStatus": iosCategoryTopStatus,
        "IOSCategoryTopAdType": iosCategoryTopAdType,
        "IOSCategoryTopAdUnit": iosCategoryTopAdUnit,
        "IOSCategoryTopAdsize": iosCategoryTopAdsize,
        "IOSCategoryFirstStatus": iosCategoryFirstStatus,
        "IOSCategoryFirstAdType": iosCategoryFirstAdType,
        "IOSCategoryFirstAdUnit": iosCategoryFirstAdUnit,
        "IOSCategoryFirstAdsize": iosCategoryFirstAdsize,
        "IOSCategorySecondStatus": iosCategorySecondStatus,
        "IOSCategorySecondAdType": iosCategorySecondAdType,
        "IOSCategorySecondAdUnit": iosCategorySecondAdUnit,
        "IOSCategorySecondAdsize": iosCategorySecondAdsize,
        "IOSCategoryCatfishStatus": iosCategoryCatfishStatus,
        "IOSCategoryCatfishAdType": iosCategoryCatfishAdType,
        "IOSCategoryCatfishAdUnit": iosCategoryCatfishAdUnit,
        "IOSCategoryCatfishAdsize": iosCategoryCatfishAdsize,
        "IOSProgramsCategoryTopStatus": iosProgramsCategoryTopStatus,
        "IOSProgramsCategoryTopAdType": iosProgramsCategoryTopAdType,
        "IOSProgramsCategoryTopAdUnit": iosProgramsCategoryTopAdUnit,
        "IOSProgramsCategoryTopAdsize": iosProgramsCategoryTopAdsize,
        "IOSProgramsCategoryFirstStatus": iosProgramsCategoryFirstStatus,
        "IOSProgramsCategoryFirstAdType": iosProgramsCategoryFirstAdType,
        "IOSProgramsCategoryFirstAdUnit": iosProgramsCategoryFirstAdUnit,
        "IOSProgramsCategoryFirstAdsize": iosProgramsCategoryFirstAdsize,
        "IOSProgramsCategorySecondStatus": iosProgramsCategorySecondStatus,
        "IOSProgramsCategorySecondAdType": iosProgramsCategorySecondAdType,
        "IOSProgramsCategorySecondAdUnit": iosProgramsCategorySecondAdUnit,
        "IOSProgramsCategorySecondAdsize": iosProgramsCategorySecondAdsize,
        "IOSProgramsCategoryCatfishStatus": iosProgramsCategoryCatfishStatus,
        "IOSProgramsCategoryCatfishAdType": iosProgramsCategoryCatfishAdType,
        "IOSProgramsCategoryCatfishAdUnit": iosProgramsCategoryCatfishAdUnit,
        "IOSProgramsCategoryCatfishAdsize": iosProgramsCategoryCatfishAdsize,
        "IOSProgramsSingleTopStatus": iosProgramsSingleTopStatus,
        "IOSProgramsSingleTopAdType": iosProgramsSingleTopAdType,
        "IOSProgramsSingleTopAdUnit": iosProgramsSingleTopAdUnit,
        "IOSProgramsSingleTopAdsize": iosProgramsSingleTopAdsize,
        "IOSProgramsSingleFirstStatus": iosProgramsSingleFirstStatus,
        "IOSProgramsSingleFirstAdType": iosProgramsSingleFirstAdType,
        "IOSProgramsSingleFirstAdUnit": iosProgramsSingleFirstAdUnit,
        "IOSProgramsSingleFirstAdsize": iosProgramsSingleFirstAdsize,
        "IOSProgramsSingleSecondStatus": iosProgramsSingleSecondStatus,
        "IOSProgramsSingleSecondAdType": iosProgramsSingleSecondAdType,
        "IOSProgramsSingleSecondAdUnit": iosProgramsSingleSecondAdUnit,
        "IOSProgramsSingleSecondAdsize": iosProgramsSingleSecondAdsize,
        "IOSProgramsSingleCatfishStatus": iosProgramsSingleCatfishStatus,
        "IOSProgramsSingleCatfishAdType": iosProgramsSingleCatfishAdType,
        "IOSProgramsSingleCatfishAdUnit": iosProgramsSingleCatfishAdUnit,
        "IOSProgramsSingleCatfishAdsize": iosProgramsSingleCatfishAdsize,
        "IOSLiveTopStatus": iosLiveTopStatus,
        "IOSLiveTopAdType": iosLiveTopAdType,
        "IOSLiveTopAdUnit": iosLiveTopAdUnit,
        "IOSLiveTopAdsize": iosLiveTopAdsize,
        "IOSLiveFirstStatus": iosLiveFirstStatus,
        "IOSLiveFirstAdType": iosLiveFirstAdType,
        "IOSLiveFirstAdUnit": iosLiveFirstAdUnit,
        "IOSLiveFirstAdsize": iosLiveFirstAdsize,
        "IOSLiveSecondStatus": iosLiveSecondStatus,
        "IOSLiveSecondAdType": iosLiveSecondAdType,
        "IOSLiveSecondAdUnit": iosLiveSecondAdUnit,
        "IOSLiveSecondAdsize": iosLiveSecondAdsize,
        "IOSLiveCatfishStatus": iosLiveCatfishStatus,
        "IOSLiveCatfishAdType": iosLiveCatfishAdType,
        "IOSLiveCatfishAdUnit": iosLiveCatfishAdUnit,
        "IOSLiveCatfishAdsize": iosLiveCatfishAdsize,
        "IOSAudioLiveTopStatus": iosAudioLiveTopStatus,
        "IOSAudioLiveTopAdType": iosAudioLiveTopAdType,
        "IOSAudioLiveTopAdUnit": iosAudioLiveTopAdUnit,
        "IOSAudioLiveTopAdsize": iosAudioLiveTopAdsize,
        "IOSAudioLiveFirstStatus": iosAudioLiveFirstStatus,
        "IOSAudioLiveFirstAdType": iosAudioLiveFirstAdType,
        "IOSAudioLiveFirstAdUnit": iosAudioLiveFirstAdUnit,
        "IOSAudioLiveFirstAdsize": iosAudioLiveFirstAdsize,
        "IOSAudioLiveSecondStatus": iosAudioLiveSecondStatus,
        "IOSAudioLiveSecondAdType": iosAudioLiveSecondAdType,
        "IOSAudioLiveSecondAdUnit": iosAudioLiveSecondAdUnit,
        "IOSAudioLiveSecondAdsize": iosAudioLiveSecondAdsize,
        "IOSAudioLiveCatfishStatus": iosAudioLiveCatfishStatus,
        "IOSAudioLiveCatfishAdType": iosAudioLiveCatfishAdType,
        "IOSAudioLiveCatfishAdUnit": iosAudioLiveCatfishAdUnit,
        "IOSAudioLiveCatfishAdsize": iosAudioLiveCatfishAdsize,
        "IOSLiveStreamStream": iosLiveStreamStream,
        "IOSLiveStreamAdUrl": iosLiveStreamAdUrl,
      };
}
