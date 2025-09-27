import 'package:flutter/material.dart';
import '../models/survivor.dart';
import '../widgets/match_card.dart';

class SurvivorDetailPage extends StatelessWidget {
  final Survivor survivor;

  SurvivorDetailPage({required this.survivor});

  Map<int, List<Match>> groupMatchesByRound(List<Match> matches) {
    final Map<int, List<Match>> grouped = {};
    for (var match in matches) {
      final round =
          matches.indexOf(match) + 1; // si no tenés round, usá index + 1
      grouped.putIfAbsent(round, () => []).add(match);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupMatchesByRound(survivor.competition);

    return ListView(
      children: grouped.entries.map((entry) {
        final round = entry.key;
        final matches = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Jornada $round',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...matches
                .map(
                  (match) => MatchCard(
                    match: match,
                    survivorId: survivor.id,
                    userId: '',
                    startDate: survivor.startDate,
                  ),
                )
                .toList(),
          ],
        );
      }).toList(),
    );
  }
}
