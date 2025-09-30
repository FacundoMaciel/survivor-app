import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

Future<void> sendPick({
  required String survivorId,
  required String matchId,
  required String teamId,
}) async {
  final url = Uri.parse("${AppConfig.apiBaseUrl}/api/pick");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: json.encode({
      "survivorId": survivorId,
      "matchId": matchId,
      "teamId": teamId,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al hacer pick: ${response.body}");
  }
}
