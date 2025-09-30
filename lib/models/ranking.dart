class RankingEntry {
  final String userId;
  final double score;
  final double lives;
  final bool eliminated;

  RankingEntry({
    required this.userId,
    required this.score,
    required this.lives,
    required this.eliminated,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      userId: json['userId'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      lives: (json['lives'] ?? 0).toDouble(),
      eliminated: json['eliminated'] ?? false,
    );
  }
}
