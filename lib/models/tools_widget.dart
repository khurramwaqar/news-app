// To parse this JSON data, do
//
//     final toolsWidger = toolsWidgerFromJson(jsonString);

import 'dart:convert';

List<ToolsWidger> toolsWidgerFromJson(String str) => List<ToolsWidger>.from(
    json.decode(str).map((x) => ToolsWidger.fromJson(x)));

String toolsWidgerToJson(List<ToolsWidger> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ToolsWidger {
  int? position;
  String? title;
  String? tag;
  String? action;
  String? icon;

  ToolsWidger({
    this.position,
    this.title,
    this.tag,
    this.action,
    this.icon,
  });

  factory ToolsWidger.fromJson(Map<String, dynamic> json) => ToolsWidger(
        position: json["position"],
        title: json["title"],
        tag: json["tag"],
        action: json["action"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "title": title,
        "tag": tag,
        "action": action,
        "icon": icon,
      };
}
