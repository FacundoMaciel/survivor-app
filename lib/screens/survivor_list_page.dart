import 'package:flutter/material.dart';
import '../models/survivor.dart';
import '../widgets/match_list_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'survivor_matches_page.dart'; // 👈 cambio aquí

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
      Uri.parse('http://localhost:4300/api/survivor'),
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

  Future<bool> joinSurvivor(String survivorId) async {
    final url = Uri.parse(
      "http://localhost:4300/api/survivor/join/$survivorId",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId}),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400 &&
          response.body.contains('User already joined')) {
        return true;
      } else {
        print("Error joining survivor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error connecting to backend: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
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
                                  })
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
                                    onPressed: () async {
                                      if (liga.isJoined) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SurvivorMatchesPage(
                                                  survivor: liga,
                                                ), // 👈
                                          ),
                                        );
                                      } else {
                                        final joined = await joinSurvivor(
                                          liga.id,
                                        );
                                        if (joined) {
                                          setState(() {
                                            liga.isJoined = true;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Colors.green[600],
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              content: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      'Te uniste con éxito al survivor, selecciona tus partidos',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SurvivorMatchesPage(
                                                    survivor: liga,
                                                  ), // 👈
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                '❌ No se pudo unir',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      liga.isJoined ? "Ver partidos" : "Unirme",
                                    ),
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
