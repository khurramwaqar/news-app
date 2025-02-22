// To parse this JSON data, do
//
//     final sidemenu = sidemenuFromJson(jsonString);

import 'dart:convert';

Sidemenu sidemenuFromJson(String str) => Sidemenu.fromJson(json.decode(str));

String sidemenuToJson(Sidemenu data) => json.encode(data.toJson());

class Sidemenu {
  List<Sidebar>? sidebar;

  Sidemenu({
    this.sidebar,
  });

  factory Sidemenu.fromJson(Map<String, dynamic> json) => Sidemenu(
        sidebar: json["Sidebar"] == null
            ? []
            : List<Sidebar>.from(
                json["Sidebar"]!.map((x) => Sidebar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Sidebar": sidebar == null
            ? []
            : List<dynamic>.from(sidebar!.map((x) => x.toJson())),
      };
}

class Sidebar {
  int? position;
  String? title;
  String? icon;
  bool? status;
  String? pageType;
  String? isPage;
  int? id;
  Sidebar(
      {this.position,
      this.title,
      this.icon,
      this.status,
      this.pageType,
      this.isPage,
      this.id});

  factory Sidebar.fromJson(Map<String, dynamic> json) => Sidebar(
      position: json["position"],
      title: json["title"],
      icon: json["icon"],
      status: json["status"],
      pageType: json["pageType"],
      isPage: json["isPage"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "position": position,
        "title": title,
        "icon": icon,
        "status": status,
        "pageType": pageType,
        "isPage": isPage,
        "id": id,
      };
}
