import 'package:flutter/material.dart';
import '../models/survivor.dart';
import '../widgets/match_list_card.dart'; // 👈 importante para reutilizar el estilo de partido
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'survivor_matches_page.dart';

class SurvivorListPage extends StatefulWidget {
  const SurvivorListPage({super.key});

  @override
  State<SurvivorListPage> createState() => _SurvivorListPageState();
}

class _SurvivorListPageState extends State<SurvivorListPage> {
  late Future<List<Survivor>> survivors;

  @override
  void initState() {
    super.initState();
    survivors = fetchSurvivors();
  }

  Future<List<Survivor>> fetchSurvivors() async {
    final response = await http.get(
      Uri.parse('http://localhost:4300/api/survivor'),
    );
    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.map((json) => Survivor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las ligas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Fondo con imagen ---
          Positioned.fill(
            child: Image.asset('assets/stadium.png', fit: BoxFit.cover),
          ),
          // --- Contenido principal ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de volver
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "ELIGE TU SURVIVOR",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Survivor>>(
                    future: survivors,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orangeAccent,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay ligas disponibles',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final ligas = snapshot.data!;

                      return ListView.builder(
                        itemCount: ligas.length,
                        itemBuilder: (context, index) {
                          final liga = ligas[index];
                          return Card(
                            color: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ExpansionTile(
                              collapsedIconColor: Colors.orangeAccent,
                              iconColor: Colors.orangeAccent,
                              title: Text(
                                liga.name,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                if (liga.competition.isNotEmpty)
                                  ...liga.competition.map((match) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: MatchListCard(
                                          match: match,
                                          startDate: liga.startDate,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                else
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "No hay partidos",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurvivorMatchesPage(
                                                survivor: liga,
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text("UNIRME"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
