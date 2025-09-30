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

  Widget _buildFlag(String flag, {double size = 28}) {
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
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _teamButton(match.home, TextAlign.start)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 16),
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
            Expanded(child: _teamButton(match.visitor, TextAlign.end)),
          ],
        ),
      ),
    );
  }

  Widget _teamButton(Team team, TextAlign align) {
    final isSelected = selectedTeamId == team.id;

    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!(team.id, match.matchId);
        }
      },
      child: Column(
        crossAxisAlignment: align == TextAlign.start
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          _buildFlag(team.flag, size: 36),
          const SizedBox(height: 6),
          Text(
            team.name,
            textAlign: align,
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
