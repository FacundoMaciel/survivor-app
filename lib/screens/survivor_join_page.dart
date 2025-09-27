import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JoinPage extends StatefulWidget {
  final String survivorId;
  final String userId; // lo vas a pasar desde tu login

  const JoinPage({Key? key, required this.survivorId, required this.userId})
      : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  bool _loading = false;
  String? _message;

  Future<void> _joinSurvivor() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    final url = Uri.parse("http://localhost:4300/api/survivor/join/${widget.survivorId}");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.userId}", // si usás token JWT
        },
      );

      if (response.statusCode == 201) {
        setState(() {
          _message = "✅ Te registraste con éxito!";
        });
      } else {
        setState(() {
          _message = "❌ Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "❌ Error de conexión: $e";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro Survivor")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _joinSurvivor,
                    icon: const Icon(Icons.sports_esports),
                    label: const Text("Registrarme"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 20),
                    Text(_message!,
                        style: const TextStyle(color: Colors.white70)),
                  ]
                ],
              ),
      ),
    );
  }
}
