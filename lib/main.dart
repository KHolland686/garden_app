// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  //defines season change for buttons, seasonal tasks and plant lists, and themes
  String selectedSeason = 'spring';
  //change to depend on current date?
  List<String> springPlants = ['Bok Choy', 'Spinach'];
  List<String> summerPlants = ['Corn', 'Cucumbers'];
  List<String> fallPlants = ['Spinach', 'Tulip bulbs'];
  List<String> winterPlants = ['...'];
  List<String> springTasks = []; // Define and initialize seasonal tasks
  List<String> summerTasks = []; 
  List<String> fallTasks = [];   
  List<String> winterTasks = [];
  List<String> taskCompletionStatus = [];
  List<String> plantCompletionStatus = []; 
  final TextEditingController plantController = TextEditingController();
  final TextEditingController taskController = TextEditingController(); 

  GardenAppState() {
  // Load plant lists
    SharedPreferences.getInstance().then((prefs) {
      springPlants = prefs.getStringList('springPlants') ?? [];
      summerPlants = prefs.getStringList('summerPlants') ?? [];
      fallPlants = prefs.getStringList('fallPlants') ?? [];
      winterPlants = prefs.getStringList('winterPlants') ?? [];
      springTasks = prefs.getStringList('springTasks') ?? []; 
      summerTasks = prefs.getStringList('summerTasks') ?? []; 
      fallTasks = prefs.getStringList('fallTasks') ?? [];     
      winterTasks = prefs.getStringList('winterTasks') ?? [];

      taskCompletionStatus = [
              ...List.generate(springTasks.length, (index) => springTasks.isEmpty ? 'false' : springTasks[index] == '1' ? 'true' : 'false'),
              ...List.generate(summerTasks.length, (index) => summerTasks[index] == '1' ? 'true' : 'false'),
              ...List.generate(fallTasks.length, (index) => fallTasks[index] == '1' ? 'true' : 'false'),
              ...List.generate(winterTasks.length, (index) => winterTasks[index] == '1' ? 'true' : 'false'),
              ];

              // Initialize plant completion status based on stored string lists
              plantCompletionStatus = [
              ...List.generate(springPlants.length, (idx) => prefs.getStringList('springPlantsStatus')?[idx] == '1' ? 'true' : 'false'),
              ...List.generate(summerPlants.length, (idx) => prefs.getStringList('summerPlantsStatus')?[idx] == '1' ? 'true' : 'false'),
              ...List.generate(fallPlants.length, (idx) => prefs.getStringList('fallPlantsStatus')?[idx] == '1' ? 'true' : 'false'),
              ...List.generate(winterPlants.length, (idx) => prefs.getStringList('winterPlantsStatus')?[idx] == '1' ? 'true' : 'false'),
            ];
            
            notifyListeners();
          });
        } 
        void togglePlantCompletionStatus(int idx) {
          // Toggle the completion status of the plant at given index
          plantCompletionStatus[idx] = 
            plantCompletionStatus[idx] == 'true' ? 'false' : 'true';
          notifyListeners();
        }

        void toggleTaskCompletionStatus(int idx) {
          // Toggle the completion status of a task
          taskCompletionStatus[idx] = 
            taskCompletionStatus[idx] == 'true' ? 'false' : 'true';
    notifyListeners();
  }

  void changeSeason(String season) {
    //changes season based on button press
    selectedSeason = season;
    notifyListeners();
  }

  void addPlant(String plantName) async{
    // adds plant to the correct season list
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
      // Save plant lists
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('springPlants', springPlants);
      prefs.setStringList('summerPlants', summerPlants);
      prefs.setStringList('fallPlants', fallPlants);
      prefs.setStringList('winterPlants', winterPlants);
    }
  }
  
  void addTask(String taskName) async{
    // adds task to the correct season list
    if (taskName.isNotEmpty) {
      switch (selectedSeason) {
      case 'spring':
        springTasks.add(taskName);
        taskCompletionStatus.add("0"); // 0 represents unchecked
        break;
      case 'summer':
        summerTasks.add(taskName);
        taskCompletionStatus.add('0');
        break;
      case 'fall':
        fallTasks.add(taskName);
        taskCompletionStatus.add('0');
        break;
      case 'winter':
        winterTasks.add(taskName);
        taskCompletionStatus.add('0');
        break;
      default:
        throw 'Unknown season: $selectedSeason';
    }
    taskController.clear();
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('springTasks', springTasks);
    prefs.setStringList('summerTasks', summerTasks);
    prefs.setStringList('fallTasks', fallTasks);
    prefs.setStringList('winterTasks', winterTasks);
    prefs.setStringList('taskCompletionStatus', taskCompletionStatus); // Store status as string list
  }
}

  ThemeData getTheme() {
    // for changing theme based on season
    switch (selectedSeason) {
      case 'spring':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green.shade50,
            background: Colors.cyan.shade200,
            onBackground: Colors.purple.shade300,
          ),
          textSelectionTheme: TextSelectionThemeData(
            // cursor & text selection color for input
            selectionColor: Colors.green.shade50,
            cursorColor: Colors.green.shade50, 
          ),
        );
      case 'summer':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink.shade50,
            background: Colors.yellow.shade200,
            onBackground: Colors.teal.shade300,
          ),
          textSelectionTheme: TextSelectionThemeData(
            // cursor & text selection color for input
            selectionColor: Colors.pink.shade50,
            cursorColor: Colors.pink.shade50, 
          ),
        );
      case 'fall':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown.shade700,
            background: Colors.orange.shade600,
            onBackground: Colors.amber.shade500,
          ),
          textSelectionTheme: TextSelectionThemeData(
            // cursor & text selection color for input
            selectionColor: Colors.brown.shade700,
            cursorColor: Colors.brown.shade700, 
          ),
        );
      case 'winter':
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple.shade900,
            background: Colors.blueGrey.shade400,
            onBackground: Colors.white,
          ),
            textSelectionTheme: TextSelectionThemeData(
            // cursor & text selection color for input
            selectionColor: Colors.green.shade50,
            cursorColor: Colors.green.shade50,
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


class Tasks extends StatelessWidget {
  //For task list
  final Function(String) onAddTask;
  final List<String> tasks;

  const Tasks({
    super.key,
    required this.onAddTask,
    required this.tasks,
  });
  
  @override
  Widget build(BuildContext context) {
    var gardenAppState  = Provider.of<GardenAppState>(context);
    ThemeData theme = Theme.of(context);
    final List<String> tasks = getSeasonalTasks(gardenAppState);

    //card to contain the list of tasks
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
                  controller: gardenAppState.taskController,
                  decoration: InputDecoration(
                    fillColor: theme.colorScheme.primary,                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.background,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'What needs to be done?',
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Enter a task: (water, weed, etc.)",
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //add the task to the list
                String taskName = gardenAppState.taskController.text;
                gardenAppState.addTask(taskName); 
                gardenAppState.taskController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.onBackground,
              ),
              child: const Text('Add Task'),
            ),
            SizedBox(height:10),
            Text(
              "To Be Done:",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.background,
              ),
            ),
            Column(
              children: List.generate(
                tasks.length,
                (idx) => ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: idx < gardenAppState.taskCompletionStatus.length && gardenAppState.taskCompletionStatus[idx] == 'true',
                        onChanged: (value) {
                          // Toggle task completion status
                          gardenAppState.toggleTaskCompletionStatus(idx);
                        },
                      ),
                      Expanded(
                        child: Text(
                          tasks[idx],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onBackground,
                            fontSize: 14.0,
                            decoration: idx < gardenAppState.taskCompletionStatus.length && gardenAppState.taskCompletionStatus[idx] == 'true' 
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
  List<String> getSeasonalTasks(GardenAppState gardenAppState) {
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
// To Be continued.....
// Add in place to add gardens/spaces, with separate, seasonal task and plant lists instead of one plant and task list for each season
