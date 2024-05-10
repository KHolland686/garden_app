// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class GardenAppState extends ChangeNotifier {
  //defines seaason change for buttons, seasonal plant lists and themes
  String selectedSeason = 'spring';
  List<String> springPlants = ['Bok Choy', 'Spinach'];
  List<String> summerPlants = ['Corn', 'Cucumbers'];
  List<String> fallPlants = ['Spinach', 'Tulip bulbs'];
  List<String> winterPlants = ['...'];
  final TextEditingController plantController = TextEditingController();

  void changeSeason(String season) {
    //changes season based on button press
    selectedSeason = season;
    notifyListeners();
  }

  void addPlant(String plantName) {
    //adds plant to the correct season list
    if (plantName.isNotEmpty) {
      switch (selectedSeason) {
        case 'spring':
          springPlants.add(plantName);
          break;
        case 'summer':
          summerPlants.add(plantName);
          break;
        case 'fall':
          fallPlants.add(plantName);
          break;
        case 'winter':
          winterPlants.add(plantName);
          break;
        default:
          throw 'Unknown season: $selectedSeason';
      }
    plantController.clear();
    notifyListeners();
  }
}
  
  ThemeData getTheme() {
    //for changing theme based on season
    switch (selectedSeason) {
      case 'spring':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade50,
            background: Colors.cyan.shade200,
            onBackground: Colors.purple.shade300,
          ),
        );
      case 'summer':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink.shade50,
            background: Colors.yellow.shade200,
            onBackground: Colors.teal.shade300,
          ),
        );
      case 'fall':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown.shade700,
            background: Colors.orange.shade600,
            onBackground: Colors.amber.shade500,
          ),
        );
      case 'winter':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple.shade900,
            background: Colors.blueGrey.shade400,
            onBackground: Colors.white,
          ),
        );
      default:
        return ThemeData.light();
    }
  }
}


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
            ],
          ),
        ),
      ),
    );
  }
}


class HeaderWidget extends StatelessWidget {
  //For Title, description and image
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String getImagePath(String season) {
        //getting correct image for selected season
      switch (season) {
        case 'spring':
          return 'assets/images/spring.jpg';
        case 'summer':
          return 'assets/images/Spud_in_garden.jpg';
        case 'fall':
          return 'assets/images/fall.jpg';
        case 'winter':
          return 'assets/images/winter.jpg';
        default:
          return 'assets/images/spring.jpg';
      }     
    }
    final String seasonImage = 
      getImagePath(Provider.of<GardenAppState>(context).selectedSeason);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Josie's Garden",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cursive',
            ),
          ),
          Text(
            "This is the place to plan out Josie's garden(s) for the year.",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Cursive',
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),

          Image.asset(
            seasonImage,
            height: 400,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

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
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary,
                width: 3.0,
              ),
              bottom: BorderSide(
                color: theme.colorScheme.primary,
                width: 3.0,
              ),
            ),
          ),
          child: Text(
            season,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        SizedBox(height: 10),
        PlantList(onAddPlant: onAddPlant),
      ],
    );
  }
}

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
                (index) => ListTile(
                  title: Text(
                    plants[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontSize: 14.0,
                      ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// adding in later
// class tasks extends StatelessWidget {
//   //For task list
//   final Function(String) onAddTask;

//   const tasks({
//     super.key,
//     required this.onAddTask,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var gardenAppState  = Provider.of<GardenAppState>(context);
//     final List<String> tasks;

//     switch (gardenAppState.selectedSeason) {
//       case 'spring':
//         tasks = gardenAppState.springTasks;
//         break;
//       case 'summer':
//         tasks = gardenAppState.summerTasks;
//         break;
//       case 'fall':
//         tasks = gardenAppState.fallTasks;
//         break;
//       case 'winter':
//         tasks = gardenAppState.winterTasks;
//         break;
//       default:
//         tasks = [];
//     }
// To Be continued.....
