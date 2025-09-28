import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultadosTab extends StatefulWidget {
  final String survivorId;
  final String userId;

  const ResultadosTab({
    Key? key,
    required this.survivorId,
    required this.userId,
  }) : super(key: key);

  @override
  State<ResultadosTab> createState() => _ResultadosTabState();
}

class _ResultadosTabState extends State<ResultadosTab>
    with AutomaticKeepAliveClientMixin {
  bool simulationDone = false;
  List<Map<String, dynamic>> results = [];

  @override
  bool get wantKeepAlive => true;

  Future<void> simulateSurvivor() async {
    final url = Uri.parse(
      "http://localhost:4300/api/survivor/simulate/${widget.survivorId}",
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final resultsMap = data["results"] as Map<String, dynamic>;

        final parsedResults = resultsMap.entries.map((entry) {
          final matchId = entry.key;
          final resultData = entry.value as Map<String, dynamic>;

          return {
            "matchId": matchId,
            "winner": resultData["winner"], // { name, flag } o null
            "userTeam": resultData["userTeam"], // <- tu selección
          };
        }).toList();

        setState(() {
          simulationDone = true;
          results = parsedResults;
        });

        debugPrint("Resultados parseados: $results");
      } else {
        debugPrint("Error simulando: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error simulando: $e");
    }
  }

  String _getStatus(Map<String, dynamic> match) {
    if (match["winner"] == null) return "Empate ⚪";

    if (match["userTeam"] != null &&
        match["winner"]["name"] == match["userTeam"]["name"]) {
      return "Ganaste ✅";
    } else {
      return "Perdiste ❌";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!simulationDone) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: simulateSurvivor,
          icon: const Icon(Icons.play_arrow),
          label: const Text("Simular"),
        ),
      );
    }

    // 🔹 Un solo menú para todos los partidos
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ExpansionTile(
          leading: const Icon(Icons.sports_soccer, color: Colors.orange),
          title: const Text(
            "Resultados de la simulación",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: results.map((match) {
            return ListTile(
              leading: match["winner"] != null
                  ? Text(
                      match["winner"]["flag"],
                      style: const TextStyle(fontSize: 24),
                    )
                  : const Icon(Icons.remove_circle, color: Colors.grey),
              title: Text("Partido ${match['matchId']}"),
              subtitle: Text(
                match["winner"] != null
                    ? "Ganador: ${match["winner"]["name"]}"
                    : "Empate",
              ),
              trailing: Text(
                _getStatus(match),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
