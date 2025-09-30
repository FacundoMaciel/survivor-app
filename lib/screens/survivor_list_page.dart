import 'package:flutter/material.dart';
import '../models/survivor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'survivor_matches_page.dart';
import '../config.dart';


class SurvivorListPage extends StatefulWidget {
  final String userId;

  const SurvivorListPage({super.key, required this.userId});

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
      Uri.parse("${AppConfig.apiBaseUrl}/api/survivor"), //("${AppConfig.apiBaseUrl}/survivors")
    );
    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Survivor.fromJson(json)..isJoined = false)
          .toList();
    } else {
      throw Exception('Error al cargar las ligas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/stadium.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            child: ListTile(
                              title: Text(
                                liga.name,
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${liga.competition.length} partidos",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurvivorMatchesPage(
                                        survivor: liga,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Ver partidos"),
                              ),
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
