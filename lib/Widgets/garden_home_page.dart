import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Models/garden_app_state.dart';
import 'package:garden_app/Widgets/header.dart';
import 'package:garden_app/Widgets/season_section.dart';
import 'package:garden_app/Widgets/tasks.dart';
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
                    ElevatedButton.icon(
                      onPressed: () {
                        gardenAppState.changeSeason('spring');
                      },
                      icon: Icon(
                        Icons.emoji_nature,
                        color: Colors.green.shade300,
                      ),
                      label: Text('Spring'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        gardenAppState.changeSeason('summer');
                      },
                      icon: Icon(
                        Icons.wb_sunny,
                        color: Colors.amber.shade300,
                      ),
                      label: Text('Summer'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        gardenAppState.changeSeason('fall');
                      },
                      icon: Icon(
                        Icons.eco,
                        color: Colors.orange.shade300,
                      ),
                      label: Text('Fall'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        gardenAppState.changeSeason('winter');
                      },
                      icon: Icon(
                        Icons.ac_unit,
                        color: Colors.blueGrey.shade300,
                      ),
                      label: Text('Winter'),
                    ),
                  ],  
                ),
              ),
              SeasonSection(
                season: gardenAppState.selectedSeason,
                onAddPlant: gardenAppState.addPlant,
              ),
              SizedBox(height: 20),
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
    switch (gardenAppState.selectedSeason) {
      case 'spring':
        return gardenAppState.springTasks;
      case 'summer':
        return gardenAppState.summerTasks;
      case 'fall':
        return gardenAppState.fallTasks;
      case 'winter':
        return gardenAppState.winterTasks;
      default:
        return [];
    }
  }
}