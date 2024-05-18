import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Models/garden_app_state.dart';


class PlantList extends StatelessWidget {
  //For plant list
  final Function(String) onAddPlant;

  const PlantList({
    super.key,
    required this.onAddPlant,
  });

  @override
  Widget build(BuildContext context) {
    var gardenAppState  = Provider.of<GardenAppState>(context);
    final List<String> plants;

    switch (gardenAppState.selectedSeason) {
      case 'spring':
        plants = gardenAppState.springPlants;
        break;
      case 'summer':
        plants = gardenAppState.summerPlants;
        break;
      case 'fall':
        plants = gardenAppState.fallPlants;
        break;
      case 'winter':
        plants = gardenAppState.winterPlants;
        break;
      default:
        plants = [];
    }
    ThemeData theme = Theme.of(context);
    //card to contain the list of plants
    return Card(
      color: theme.colorScheme.primary,
      shadowColor: theme.colorScheme.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0),
      ),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250,
                child: TextField(
                  controller: gardenAppState.plantController,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.background,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.background,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'What needs to be planted?',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Enter a plant name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                gardenAppState.addPlant(gardenAppState.plantController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.onBackground,
              ),
              child: const Text('Add Plant'),
            ),
            SizedBox(height:10),
            Text(
              "To Be Planted:",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.background,
              ),
            ),
            Column(
              children: List.generate(
                plants.length,
                (idx) => ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: idx < gardenAppState.plantCompletionStatus.  length &&
                          gardenAppState.plantCompletionStatus[idx] == 'true',
                        onChanged: (value) {
                          // Toggle task completion status
                          gardenAppState.togglePlantCompletionStatus(idx);
                        },
                      ),
                      Expanded(
                        child: Text(
                          plants[idx],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 14.0,
                            decoration: idx < gardenAppState.plantCompletionStatus.length && gardenAppState.plantCompletionStatus[idx] == 'true'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<String> getSeasonalPlants(GardenAppState gardenAppState) {
    switch (gardenAppState.selectedSeason) {
      case 'spring':
        return gardenAppState.springPlants;
      case 'summer':
        return gardenAppState.summerPlants;
      case 'fall':
        return gardenAppState.fallPlants;
      case 'winter':
        return gardenAppState.winterPlants;
      default:
        return [];
    }
  }
}