class Survivor {
  final String id;
  final String name;
  final int lives;
  final List<Jornada> competition;
  final DateTime startDate;

  bool isJoined;

  Survivor({
    required this.id,
    required this.name,
    required this.lives,
    required this.competition,
    required this.startDate,
    this.isJoined = false,
  });

  factory Survivor.fromJson(Map<String, dynamic> json) {
    return Survivor(
      id: (json['_id'] ?? json['id'] ?? "").toString(),
      name: json['name'] ?? "Sin nombre",
      lives: json['lives'] ?? 0,
      competition: (json['competition'] as List? ?? [])
          .map((j) => Jornada.fromJson(j))
          .toList(),
      startDate: DateTime.tryParse(json['startDate'] ?? "") ?? DateTime.now(),
    );
  }
}

class Jornada {
  final int jornada;
  final List<Match> matches;

  Jornada({
    required this.jornada,
    required this.matches,
  });

  factory Jornada.fromJson(Map<String, dynamic> json) {
    return Jornada(
      jornada: json['jornada'] ?? 0,
      matches: (json['matches'] as List? ?? [])
          .map((m) => Match.fromJson(m))
          .toList(),
    );
  }
}

class Match {
  final String matchId;
  final Team home;
  final Team visitor;
  final DateTime date;

  Match({
    required this.matchId,
    required this.home,
    required this.visitor,
    required this.date,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: (json['matchId'] ?? "").toString(),
      home: Team.fromJson(json['home'] ?? {}),
      visitor: Team.fromJson(json['visitor'] ?? {}),
      date: DateTime.tryParse(json['date'] ?? "") ?? DateTime.now(),
    );
  }
}

class Team {
  final String id;
  final String name;
  final String flag;

  Team({
    required this.id,
    required this.name,
    required this.flag,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: (json['_id'] ?? json['id'] ?? "").toString(),
      name: json['name'] ?? "Equipo",
      flag: json['flag'] ?? "",
    );
  }
}
