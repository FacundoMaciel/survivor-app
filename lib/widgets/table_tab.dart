import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ranking.dart';

class TableTab extends StatefulWidget {
  final String survivorId;
  final String currentUserId; // ✅ usuario actual

  const TableTab({
    Key? key,
    required this.survivorId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<TableTab> createState() => _TableTabState();
}

class _TableTabState extends State<TableTab> {
  List<RankingEntry> ranking = [];
  bool isLoading = true;

  /// Lista de nombres fake para mostrar en lugar de userId
  final List<String> fakeNames = [
    "Jugador Pro",
    "Crack del Gol",
    "Capitán Frío",
    "La Bestia",
    "El Mago",
    "Tiburón",
    "Rayo",
    "Pistolero",
    "Pantera",
    "Dragón",
  ];

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    try {
      final url = Uri.parse(
        "http://localhost:4300/api/survivor/ranking/${widget.survivorId}",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rankingList = (data["ranking"] as List)
            .map((r) => RankingEntry.fromJson(r))
            .toList();

        // 🔹 ordenar ranking por score y luego vidas
        rankingList.sort((a, b) {
          final scoreDiff = b.score.compareTo(a.score);
          if (scoreDiff != 0) return scoreDiff;
          return b.lives.compareTo(a.lives);
        });

        setState(() {
          ranking = rankingList;
          isLoading = false;
        });
      } else {
        throw Exception("Error al cargar ranking");
      }
    } catch (e) {
      debugPrint("Ranking error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (ranking.isEmpty) {
      return const Center(child: Text("No hay jugadores todavía"));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: ranking.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final player = ranking[index];
        final position = index + 1;

        /// Elegimos un nombre fake random
        final fakeName = fakeNames[random.nextInt(fakeNames.length)];

        // 🔹 identificar si es el usuario actual
        final isCurrentUser = player.userId == widget.currentUserId;

        return ListTile(
          tileColor: isCurrentUser
              ? Colors.orange.shade800.withOpacity(0.5)
              : null,
          leading: CircleAvatar(
            backgroundColor: position == 1
                ? Colors.amber
                : position == 2
                ? Colors.grey
                : position == 3
                ? Colors.brown
                : Colors.blue.shade200,
            child: Text(
              "$position",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          title: Row(
            children: [
              Text(
                fakeName,
                style: TextStyle(
                  fontWeight: isCurrentUser
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: player.eliminated ? Colors.grey : Colors.white,
                ),
              ),
              if (position == 1) ...[
                const SizedBox(width: 6),
                const Icon(Icons.emoji_events, color: Colors.yellow), // 🏆
              ],
            ],
          ),
          subtitle: Text(
            "Vidas: ${player.lives <= 0 ? 0 : (player.lives % 1 == 0 ? player.lives.toInt() : player.lives)}",
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: player.eliminated
              ? const Icon(Icons.close, color: Colors.red)
              : const Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }
}
