import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wordpress_app/models/tools_widget.dart';
// Adjust the path as needed

class ToolsWidgetService {
  final String apiUrl =
      "https://api.arynews.tv/v3/toolWidget.json?id=12345"; // Replace with your API endpoint

  Future<List<ToolsWidget>> fetchToolsWidget() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ToolsWidget.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load tools data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
