// To parse this JSON data, do
//
//     final toolsWidger = toolsWidgerFromJson(jsonString);

import 'dart:convert';

List<ToolsWidget> toolsWidgetFromJson(String str) => List<ToolsWidget>.from(
    json.decode(str).map((x) => ToolsWidget.fromJson(x)));

String toolsWidgetToJson(List<ToolsWidget> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ToolsWidget {
  int? position;
  String? title;
  String? tag;
  String? action;
  String? icon;
  String? iconF;

  ToolsWidget(
      {this.position,
      this.title,
      this.tag,
      this.action,
      this.icon,
      this.iconF});

  factory ToolsWidget.fromJson(Map<String, dynamic> json) => ToolsWidget(
      position: json["position"],
      title: json["title"],
      tag: json["tag"],
      action: json["action"],
      icon: json["icon"],
      iconF: json["iconF"]);

  Map<String, dynamic> toJson() => {
        "position": position,
        "title": title,
        "tag": tag,
        "action": action,
        "icon": icon,
        "iconF": iconF,
      };
}
