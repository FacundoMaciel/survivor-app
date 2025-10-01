import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

Future<void> fetchUserStatus(String userId, String survivorId) async {
  final url = Uri.parse(
    "${AppConfig.apiBaseUrl}/api/survivor/status/$userId/$survivorId",
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error en la respuesta: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("❌ Error al cargar estado del usuario: $e");
    return;
  }
}
