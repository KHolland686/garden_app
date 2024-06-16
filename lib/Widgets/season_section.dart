import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Widgets/plant_list.dart';
import 'package:garden_app/Models/garden_app_state.dart';


class SeasonSection extends StatelessWidget {
    //sets season title and calls plant list within
  final String season;
  final Function(String) onAddPlant;

  const SeasonSection({
    super.key,
    required this.season,
    required this.onAddPlant,
  });


  @override
  Widget build(BuildContext context) {
    var gardenAppState = context.watch<GardenAppState>();
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.colorScheme.primary, width: 3),
              bottom: BorderSide(color: theme.colorScheme.primary, width: 3),
            ),
          ),
          child: Text(
            'Season: ${gardenAppState.selectedSeason}',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cursive',
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        SizedBox(height: 10),
        PlantList(
          plants: gardenAppState.currentGardenSpace.seasonalPlants[season] ?? [],
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: gardenAppState.plantController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Add a plant',
              hintText: 'Enter plant name',
              suffixIcon: IconButton(
                onPressed: () {
                  onAddPlant(gardenAppState.plantController.text);
                },
                icon: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}