// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Widgets/garden_home_page.dart';
import 'package:garden_app/Models/garden_app_state.dart';


void main() {
  runApp(GardenApp());
}


class GardenApp extends StatelessWidget {
  const GardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GardenAppState(),
      child: Consumer<GardenAppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Garden App',
            theme: appState.getTheme(),
            home: GardenHomePage(),
          );
        },
      ),
    );
  }
}

// To Be continued.....