import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Models/garden_app_state.dart';
import 'package:garden_app/Widgets/header.dart';
import 'package:garden_app/Widgets/season_section.dart';
import 'package:garden_app/Widgets/tasks.dart';
import 'package:garden_app/Widgets/plant_list.dart';
// import

class GardenHomePage extends StatelessWidget {
  //Home page for garden app
  const GardenHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var gardenAppState = context.watch<GardenAppState>();
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: Text(
          "Josie's Garden",
          style: TextStyle(
            fontSize: 18.0,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cursive',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderWidget(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSeasonButton(
                      context,
                      'spring',
                      Icons.emoji_nature,
                      Colors.purple.shade200,
                      'Spring',
                    ),
                    SizedBox(width: 10),
                    buildSeasonButton(
                      context,
                      'summer',
                      Icons.wb_sunny,
                      Colors.amber.shade300,
                      'Summer',
                    ),
                    SizedBox(width: 10),
                    buildSeasonButton(
                      context,
                      'fall',
                      Icons.eco,
                      Colors.orange.shade300,
                      'Fall',
                    ),
                    SizedBox(width: 10),
                    buildSeasonButton(
                      context,
                      'winter',
                      Icons.ac_unit,
                      Colors.blueGrey.shade300,
                      'Winter',
                    ),
                  ],  
                ),
              ),
              SeasonSection(
                season: gardenAppState.selectedSeason,
                onAddPlant: gardenAppState.addPlant,
              ),
              SizedBox(height: 20),
              PlantList(
                plants: getSeasonalPlants(gardenAppState),
              ),
              Tasks(
                onAddTask: gardenAppState.addTask,
                tasks: getSeasonalTasks(gardenAppState),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> getSeasonalTasks(GardenAppState gardenAppState) {
    //returns the correct task list based on season
    return gardenAppState.currentGardenSpace.seasonalTasks[gardenAppState.selectedSeason]!;
  }

  List<String> getSeasonalPlants(GardenAppState gardenAppState) {
    //returns the correct plant list based on season
    return gardenAppState.currentGardenSpace.seasonalPlants[gardenAppState.selectedSeason]!;
  }

  Widget buildSeasonButton(
    BuildContext context,
    String season,
    IconData icon,
    Color iconColor,
    String label,
  ) {
    //builds a button for each season
    var gardenAppState = context.watch<GardenAppState>();
    ThemeData theme = Theme.of(context);

    Color buttonBackgroundColor;
    Color buttonTextColor = theme.colorScheme.onBackground;

  // Determine button colors based on the selected season
    switch (gardenAppState.selectedSeason) { 
      case 'spring':
        buttonBackgroundColor = Colors.green.shade300;
        break;
      case 'summer':
        buttonBackgroundColor = Colors.pink.shade300;
        break;
      case 'fall':
        buttonBackgroundColor = Colors.brown.shade300;
        break;
      case 'winter':
        buttonBackgroundColor = Colors.deepPurple.shade300;
        break;
        default:
        buttonBackgroundColor = Colors.grey.shade300;
        break;
    }

    return ElevatedButton.icon(
      onPressed: () {
        gardenAppState.selectedSeason = season;
      },
      icon: Icon(
        icon,
        color: iconColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: buttonTextColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBackgroundColor,
        foregroundColor: buttonTextColor,
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
      ),
    );
  }
}