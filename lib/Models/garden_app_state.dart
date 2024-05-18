import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    prefs.setStringList('taskCompletionStatus', taskCompletionStatus); 
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