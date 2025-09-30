import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/survivor.dart';
import '../widgets/match_card.dart';
import '../widgets/results_tab.dart';
import '../widgets/table_tab.dart';

class SurvivorMatchesPage extends StatefulWidget {
  final Survivor survivor;
  final String userId;

  const SurvivorMatchesPage({
    super.key,
    required this.survivor,
    required this.userId,
  });

  @override
  State<SurvivorMatchesPage> createState() => _SurvivorMatchesPageState();
}

class _SurvivorMatchesPageState extends State<SurvivorMatchesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Survivor? selectedSurvivor;

  final Map<String, String> selectedTeams = {};
  bool isProcessing = false;
  bool alreadyJoined = false;
  bool simulationDone = false;

  int? userLives;
  int? userPosition;
  int? totalPlayers;
  int? activePlayers;
  int prizePool = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    selectedSurvivor = widget.survivor;
    prizePool = (1000 + (DateTime.now().millisecondsSinceEpoch % 5000));
    fetchUserStatus(); // al cargar traemos vidas, posición y sobrevivientes
  }

  /// Traer estado actual (vidas, posición, sobrevivientes, etc.)
  Future<void> fetchUserStatus() async {
    final url = Uri.parse(
      "http://localhost:4300/api/survivor/status/${widget.userId}/${widget.survivor.id}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userLives = data["lives"];
          userPosition = data["position"];
          totalPlayers = data["total"];
          activePlayers = data["active"];
          alreadyJoined = data["joined"] ?? false;
        });
      }
    } catch (e) {
      debugPrint("Error al cargar estado del usuario: $e");
    }
  }

  /// Unirse y enviar predicciones
  Future<void> submitSelections() async {
    if (selectedTeams.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Debes seleccionar al menos un equipo"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isProcessing = true);

    final joinUrl = Uri.parse(
      "http://localhost:4300/api/survivor/join/${widget.survivor.id}",
    );
    final predictUrl = Uri.parse(
      "http://localhost:4300/api/survivor/predict/${widget.survivor.id}",
    );

    try {
      final joinResponse = await http.post(
        joinUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId}),
      );

      if (joinResponse.statusCode == 201 || joinResponse.statusCode == 200) {
        setState(() => alreadyJoined = true);

        final predictions = selectedTeams.entries
            .map((e) => {"matchId": e.key, "teamId": e.value})
            .toList();

        final predictResponse = await http.post(
          predictUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "userId": widget.userId,
            "predictions": predictions,
          }),
        );

        if (predictResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Te uniste y guardaste tus selecciones"),
              backgroundColor: Colors.green,
            ),
          );
          fetchUserStatus(); // actualizar vidas/posición después de unirse
        } else {
          throw Exception(predictResponse.body);
        }
      } else if (joinResponse.statusCode == 400) {
        setState(() => alreadyJoined = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Ya seleccionaste resultados en este survivor"),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        throw Exception(joinResponse.body);
      }
    } catch (e) {
      setState(() => alreadyJoined = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  /// Simular partidos del survivor actual
  Future<void> simulateSurvivor() async {
    final url = Uri.parse(
      "http://localhost:4300/api/survivor/simulate/${widget.survivor.id}",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() => simulationDone = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎲 Simulación completada"),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error al simular: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final survivor = widget.survivor;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 220,
              backgroundColor: Colors.transparent,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/stadium.png', fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.6)),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 40,),
                            Text(
                              selectedSurvivor?.name ?? 'SURVIVOR',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statCard(
                              userLives != null
                                  ? "${userLives! <= 0 ? 0 : userLives}"
                                  : "${survivor.lives}",
                              "VIDAS",
                              Icons.favorite,
                              Colors.red,
                            ),
                            _statCard(
                              userPosition != null && totalPlayers != null
                                  ? "$userPosition/$totalPlayers"
                                  : "-",
                              "POSICIÓN",
                              Icons.emoji_events,
                              Colors.yellow,
                            ),
                            _statCard(
                              "\$$prizePool",
                              "POZO",
                              Icons.attach_money,
                              Colors.orangeAccent,
                            ),
                            _statCard(
                              activePlayers != null ? "$activePlayers" : "-",
                              "SOBREVIVIENTES",
                              Icons.people_alt,
                              Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              "assets/penkaLogo.png",
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "By PENKA",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
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
              // TAB "Por jugar"
              ListView(
                primary: false,
                padding: const EdgeInsets.all(8),
                children: survivor.competition.expand((jornada) {
                  return [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        "Jornada ${jornada.jornada}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    ...jornada.matches.map((match) {
                      final selectedTeamId = selectedTeams[match.matchId];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MatchCard(
                            match: match,
                            survivorId: survivor.id,
                            userId: widget.userId,
                            startDate: survivor.startDate,
                            selectedTeamId: selectedTeamId,
                            onSelect: (teamId, matchId) {
                              setState(() {
                                selectedTeams[matchId] = teamId;
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ];
                }).toList(),
              ),

              // TAB "Resultados"
              ResultadosTab(survivorId: survivor.id, userId: widget.userId),

              // TAB "Tabla"
              TableTab(survivorId: survivor.id, currentUserId: widget.userId),
            ],
          ),
        ),

        /// Botón "Unirme" solo visible si no está unido
        bottomNavigationBar: alreadyJoined
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: isProcessing ? null : submitSelections,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Unirme",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
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
