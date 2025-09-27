import 'package:flutter/material.dart';
import '../models/survivor.dart';
import '../widgets/match_card.dart';

class SurvivorDetailPage extends StatelessWidget {
  final Survivor survivor;

  const SurvivorDetailPage({super.key, required this.survivor});

  /// Agrupa los partidos por ronda (si no hay propiedad 'round', usamos index + 1)
  Map<int, List<Match>> groupMatchesByRound(List<Match> matches) {
    final Map<int, List<Match>> grouped = {};
    for (var i = 0; i < matches.length; i++) {
      final round = i + 1;
      grouped.putIfAbsent(round, () => []).add(matches[i]);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMatches = groupMatchesByRound(survivor.competition);

    return Scaffold(
      appBar: AppBar(
        title: Text(survivor.name),
        backgroundColor: Colors.orangeAccent,
      ),
      body: groupedMatches.isEmpty
          ? const Center(
              child: Text(
                'No hay partidos disponibles',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView(
              children: groupedMatches.entries.map((entry) {
                final round = entry.key;
                final matches = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Jornada $round',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    ...matches.map(
                      (match) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: MatchCard(
                          match: match,
                          survivorId: survivor.id,
                          userId: '', // si en el futuro tenés userId, pasalo aquí
                          startDate: survivor.startDate,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
