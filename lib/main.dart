import 'package:flutter/material.dart';
import 'package:survivor_app/screens/survivor_home_page.dart';
import 'styles/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const SurvivorApp());
}

class SurvivorApp extends StatelessWidget {
  const SurvivorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survivor App',
      theme: darkTheme,
      locale: const Locale('es'),
      home: const HomePage(),
    );
  }
}
