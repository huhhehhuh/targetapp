import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'package:targetapp/screens/home.dart';

class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Target App',
        routes: {
          '/': (context) => const Home(),
        },
      ),
    );
  }
}
