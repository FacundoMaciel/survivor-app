import 'package:flutter/material.dart';
import '../models/survivor.dart';
import 'package:intl/intl.dart';
import '../services/pick_match_service.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final String survivorId;
  final String userId;
  final DateTime startDate;

  const MatchCard({
    Key? key,
    required this.match,
    required this.survivorId,
    required this.userId,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1F1F), Color(0xFF1F1F1F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            // Equipo local
            Expanded(
              flex: 3,
              child: _pickButton(
                context,
                label: match.home.name,
                onTap: () => _handlePick(context, match.matchId, match.home.id),
                alignRight: false,
                icon: Icons.sports_soccer,
              ),
            ),

            // Fecha y hora
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('d MMM', 'es').format(startDate).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(startDate),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Equipo visitante
            Expanded(
              flex: 3,
              child: _pickButton(
                context,
                label: match.visitor.name,
                onTap: () =>
                    _handlePick(context, match.matchId, match.visitor.id),
                alignRight: true,
                icon: Icons.sports_soccer_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool alignRight = false,
    IconData? icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.transparent,
        hoverColor: Colors.deepPurpleAccent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: alignRight
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!alignRight && icon != null) ...[
                Icon(icon, size: 18, color: Colors.white70),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  textAlign: alignRight ? TextAlign.right : TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (alignRight && icon != null) ...[
                const SizedBox(width: 6),
                Icon(icon, size: 18, color: Colors.white70),
              ],
            ],
          ),
        ),
      ),
    );
  }

  //   Future<void> _handlePick(
  //       BuildContext context, String matchId, String teamId) async {
  //     try {
  //       await sendPick(
  //         matchId: matchId,
  //         teamId: teamId,
  //         survivorId: '',
  //       );

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Pick registrado')),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }

  Future<void> _handlePick(
    BuildContext context,
    String matchId,
    String teamId,
  ) async {
    try {
      await sendPick(survivorId: '123', matchId: matchId, teamId: teamId);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pick registrado')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
