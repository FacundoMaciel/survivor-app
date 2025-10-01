import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
class ApiService {
  static const String baseUrl = "${AppConfig.apiBaseUrl}/api/survivor"; // "${AppConfig.apiBaseUrl}/api/survivor"

  Future<List<dynamic>> getSurvivors() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
