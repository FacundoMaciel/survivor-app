import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    if (flag.isEmpty) {
      return Icon(Icons.flag, size: size, color: Colors.grey);
    }
    if (flag.startsWith("http")) {
      return Image.network(flag, width: size, height: size, fit: BoxFit.cover);
    }
    if (flag.endsWith(".png") || flag.endsWith(".jpg")) {
      return Image.asset(flag, width: size, height: size, fit: BoxFit.cover);
    }
    return Text(flag, style: TextStyle(fontSize: size));
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat("dd/MM HH:mm").format(match.date);

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
                Column(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.white70, size: 16),
                    const SizedBox(height: 4),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
