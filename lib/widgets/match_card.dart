import 'package:flutter/material.dart';
import '../models/survivor.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final String survivorId;
  final String userId;
  final DateTime startDate;
  final String? selectedTeamId;
  final Function(String teamId, String matchId)? onSelect;

  const MatchCard({
    super.key,
    required this.match,
    required this.survivorId,
    required this.userId,
    required this.startDate,
    this.selectedTeamId,
    this.onSelect,
  });

  Widget _buildFlag(String flag, {double size = 32}) {
    // Si es URL (http/https)
    if (flag.startsWith("http")) {
      return Image.network(flag, width: size, height: size, fit: BoxFit.cover);
    }
    // Si es asset (ejemplo termina en .png o .jpg)
    if (flag.endsWith(".png") || flag.endsWith(".jpg")) {
      return Image.asset(flag, width: size, height: size, fit: BoxFit.cover);
    }
    // Si es emoji → mostrar como texto
    return Text(
      flag,
      style: TextStyle(fontSize: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _teamButton(match.home),
                const Text("vs", style: TextStyle(color: Colors.white)),
                _teamButton(match.visitor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamButton(Team team) {
    final isSelected = selectedTeamId == team.id;

    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!(team.id, match.matchId);
        }
      },
      child: Column(
        children: [
          _buildFlag(team.flag, size: 40),
          const SizedBox(height: 6),
          Text(
            team.name,
            style: TextStyle(
              color: isSelected ? Colors.orangeAccent : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
