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
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> simulateSurvivor() async {
    final url = Uri.parse(
      "http://localhost:4300/api/survivor/simulate/${widget.survivorId}",
    );

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final resultsMap = data["results"] as Map<String, dynamic>;

        final parsedResults = resultsMap.entries.map((entry) {
          final matchId = entry.key;
          final resultData = entry.value as Map<String, dynamic>;

          return {
            "matchId": matchId,
            "winner": resultData["winner"],
            "userTeam": resultData["userTeam"],
          };
        }).toList();

        setState(() {
          simulationDone = true; 
          results = parsedResults;
        });

        debugPrint("Resultados parseados: $results");
      } else {
        debugPrint("Error simulando: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Error: ${response.body}"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error simulando: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Error en la simulación"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
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

    // 🔹 Si no hay resultados todavía, mostrar botón de simulación
    if (results.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : simulateSurvivor,
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_arrow),
          label: const Text("Simular"),
        ),
      );
    }

    // 🔹 Si ya hay resultados, mostrar el listado en un ExpansionTile
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
