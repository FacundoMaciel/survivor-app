import 'package:flutter/material.dart';
import '../models/survivor.dart';
import '../widgets/match_card.dart';

class SurvivorMatchesPage extends StatefulWidget {
  final Survivor survivor;
  const SurvivorMatchesPage({super.key, required this.survivor});

  @override
  State<SurvivorMatchesPage> createState() => _SurvivorMatchesPageState();
}

class _SurvivorMatchesPageState extends State<SurvivorMatchesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Survivor? selectedSurvivor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    selectedSurvivor = widget.survivor;
  }

  @override
  Widget build(BuildContext context) {
    final survivor = widget.survivor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 220,
              backgroundColor: Colors.transparent,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/stadium.png', fit: BoxFit.cover),
                  Container(
                    color: Colors.black.withOpacity(0.8),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedSurvivor?.name ?? 'SURVIVOR',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statCard(
                              "${survivor.lives}/3",
                              "VIDAS",
                              Icons.favorite,
                              Colors.red,
                            ),
                            _statCard(
                              "22/12,245",
                              "POSICIÓN",
                              Icons.emoji_events,
                              Colors.yellow,
                            ),
                            _statCard(
                              "\$20K",
                              "POZO",
                              Icons.savings,
                              Colors.blueAccent,
                            ),
                            _statCard(
                              "${survivor.competition.length}",
                              "PARTIDOS",
                              Icons.sports_soccer,
                              Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.orangeAccent,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.orangeAccent,
                tabs: const [
                  Tab(text: "Por jugar"),
                  Tab(text: "Resultados"),
                  Tab(text: "Tabla"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                padding: const EdgeInsets.all(8),
                children: survivor.competition
                    .map(
                      (match) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MatchCard(
                            match: match,
                            survivorId: survivor.id,
                            userId: '',
                            startDate: survivor.startDate,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Center(child: Text("Resultados (en construcción)")),
              const Center(child: Text("Tabla (en construcción)")),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }
}
