import 'package:flutter/material.dart';

import 'screens/input_page.dart';

void main() => runApp(const SimuladorApp());

/// Widget raiz: define o tema e a tela inicial.
class SimuladorApp extends StatelessWidget {
  const SimuladorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador de Investimentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const InputPage(),
    );
  }
}
