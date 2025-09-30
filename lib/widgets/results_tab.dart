import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

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

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  /// 🔹 Trae los resultados ya guardados en DB
  Future<void> fetchResults() async {
    final url = Uri.parse(
      "${AppConfig.apiBaseUrl}/api/survivor/results/${widget.userId}/${widget.survivorId}",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          results = List<Map<String, dynamic>>.from(data["results"]);
          simulationDone = data["simulationDone"] ?? false;
        });

        debugPrint("Resultados cargados: $results");
      } else {
        debugPrint("Error obteniendo resultados: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetchResults: $e");
    }
  }

  /// 🔹 Ejecuta simulación y luego vuelve a traer resultados actualizados
  Future<void> simulateSurvivor() async {
    final url = Uri.parse(
      "${AppConfig.apiBaseUrl}/api/survivor/simulate/${widget.survivorId}",
    );

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId}),
      );

      if (response.statusCode == 200) {
        debugPrint("Simulación guardada en backend");
        await fetchResults(); // 🔹 refrescamos los datos desde DB
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

  /// 🔹 Determina estado del usuario en cada partido
  String _getStatus(Map<String, dynamic> match) {
    switch (match["result"]) {
      case "success":
        return "Ganaste ✅";
      case "fail":
        return "Perdiste ❌";
      case "pending":
        return "Pendiente ⏳";
      default:
        return "No participaste ⚪";
    }
  }

  /// 🔹 Devuelve nombre del equipo elegido por el usuario
  String _getUserTeamName(Map<String, dynamic> match) {
    if (match["home"]["_id"] == match["userTeam"]) {
      return match["home"]["name"];
    }
    if (match["visitor"]["_id"] == match["userTeam"]) {
      return match["visitor"]["name"];
    }
    return "No elegido";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 🔹 Mostrar botón de simulación si no se hizo
    final showSimulateButton = !simulationDone;

    return Column(
      children: [
        if (showSimulateButton)
          Padding(
            padding: const EdgeInsets.all(12),
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
          ),
        Expanded(
          child: ListView(
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
                      "Tu equipo: ${_getUserTeamName(match)}\n"
                      "Ganador: ${match["winner"] != null ? match["winner"]["name"] : "Empate"}",
                    ),
                    trailing: Text(
                      _getStatus(match),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
