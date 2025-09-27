class Survivor {
  final String id;
  final String name;
  final DateTime startDate;
  final int lives;
  final List<Match> competition;

  Survivor({
    required this.id,
    required this.name,
    required this.startDate,
    required this.lives,
    required this.competition,
  });

  factory Survivor.fromJson(Map<String, dynamic> json) {
    return Survivor(
      id: json['_id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      lives: json['lives'] ?? 3,
      competition: (json['competition'] as List)
          .map((m) => Match.fromJson(m))
          .toList(),
    );
  }
}

class Match {
  final String matchId;
  final Team home;
  final Team visitor;

  Match({
    required this.matchId,
    required this.home,
    required this.visitor,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: json['matchId'],
      home: Team.fromJson(json['home']),
      visitor: Team.fromJson(json['visitor']),
    );
  }
}

class Team {
  final String id;
  final String name;
  final String flag;

  Team({required this.id, required this.name, required this.flag});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'],
      name: json['name'],
      flag: json['flag'],
    );
  }
}