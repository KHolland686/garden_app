import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class GardenSpace {
  //In order to add and manage multiple garden spaces, with their own plant and task lists
  String name;
  Map<String, List<String>> seasonalPlants;
  Map<String, List<String>> seasonalTasks;
  Map<String, List<bool>> taskCompletionStatus;
  Map<String, List<bool>> plantCompletionStatus;

  GardenSpace({
    required this.name,
    required this.seasonalPlants,
    required this.seasonalTasks,
    required this.taskCompletionStatus,
    required this.plantCompletionStatus,
  });

  
  Map<String, dynamic> toJson() {
    // Convert GardenSpace to JSON
    return {
      'name': name,
      'seasonalPlants': seasonalPlants,
      'seasonalTasks': seasonalTasks,
      'taskCompletionStatus': taskCompletionStatus.map((key, value) =>
          MapEntry(key, value.map((e) => e ? 1 : 0).toList())),
      'plantCompletionStatus': plantCompletionStatus.map((key, value) =>
          MapEntry(key, value.map((e) => e ? 1 : 0).toList())),
    };
  }
  
  factory GardenSpace.fromJson(Map<String, dynamic> json) {
    // Convert JSON to GardenSpace
    return GardenSpace(
      name: json['name'],
      seasonalPlants: Map<String, List<String>>.from(json['seasonalPlants']),
      seasonalTasks: Map<String, List<String>>.from(json['seasonalTasks']),
      taskCompletionStatus: (json['taskCompletionStatus'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List).map((e) => e == 1).toList()),
      ),
      plantCompletionStatus: (json['plantCompletionStatus'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List).map((e) => e == 1).toList())),
    );
  }
}

class GardenAppState extends ChangeNotifier {
  //defines season change for buttons, seasonal tasks and plant lists, and themes
  // String selectedSeason = 'spring';  
  // Starting season depends on current date
  String selectedSeason = getInitialSeason();
  String selectedGardenSpace = 'Default';

  Map<String, GardenSpace> gardenSpaces = {
    'Default': GardenSpace(
      name: 'Default',
      seasonalPlants: {
        'spring': ['Bok Choy', 'Spinach'],
        'summer': ['Corn', 'Cucumbers'],
        'fall': ['Spinach', 'Tulip bulbs'],
        'winter': [],
      },
      seasonalTasks: {
        'spring': [],
        'summer': [],
        'fall': [],
        'winter': [],
      },
      taskCompletionStatus: {
        'spring': [],
        'summer': [],
        'fall': [],
        'winter': [],
      },
      plantCompletionStatus: {
        'spring': [],
        'summer': [],
        'fall': [],
        'winter': [],
      },
    ),
  };

  final TextEditingController plantController = TextEditingController();
  final TextEditingController taskController = TextEditingController(); 

  GardenAppState() {
  // Load plant lists
    loadGardenSpaces();
  }

static String getInitialSeason() {
    // Get the current season based on the current date
    DateTime now = DateTime.now();
    if (now.month >= 3 && now.month <= 5) {
      return 'spring';
    } else if (now.month >= 6 && now.month <= 8) {
      return 'summer';
    } else if (now.month >= 9 && now.month <= 11) {
      return 'fall';
    } else {
      return 'winter';
    }
}

  Future<void> loadGardenSpaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gardenSpacesJson = prefs.getString('gardenSpaces');
    if (gardenSpacesJson != null) {
      Map<String, dynamic> gardenSpacesMap = json.decode(gardenSpacesJson);
      gardenSpaces = gardenSpacesMap.map((key, value) => MapEntry(key, GardenSpace.fromJson(value)));
      notifyListeners();
    }
  }

  Future<void> saveGardenSpaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gardenSpacesJson = json.encode(gardenSpaces.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString('gardenSpaces', gardenSpacesJson);
  }

  void changeSeason(String season) {
    //changes season based on button press
    selectedSeason = season;
    notifyListeners();
  }

  void changeGardenSpace(String gardenSpace) {
    selectedGardenSpace = gardenSpace;
    notifyListeners();
  }

  void addGardenSpace(String gardenSpaceName) {
    if (!gardenSpaces.containsKey(gardenSpaceName)) {
      gardenSpaces[gardenSpaceName] = GardenSpace(
        name: gardenSpaceName,
        seasonalPlants: {
          'spring': [],
          'summer': [],
          'fall': [],
          'winter': [],
        },
        seasonalTasks: {
          'spring': [],
          'summer': [],
          'fall': [],
          'winter': [],
        },
        taskCompletionStatus: {
          'spring': [],
          'summer': [],
          'fall': [],
          'winter': [],
        },
        plantCompletionStatus: {
          'spring': [],
          'summer': [],
          'fall': [],
          'winter': [],
        },
      );
      saveGardenSpaces();
      notifyListeners();
    }
  }

  GardenSpace get currentGardenSpace => gardenSpaces[selectedGardenSpace]!;

  void addPlant(String plantName) async{
    // adds plant to the correct season list
    if (plantName.isNotEmpty) {
      currentGardenSpace.seasonalPlants[selectedSeason]!.add(plantName);
      currentGardenSpace.plantCompletionStatus[selectedSeason]!.add(false);
      plantController.clear();
      saveGardenSpaces();
      notifyListeners();
    }
  }

  void addTask(String taskName) async{
    // adds task to the correct season list
    if (taskName.isNotEmpty) {
      currentGardenSpace.seasonalTasks[selectedSeason]!.add(taskName);
      currentGardenSpace.taskCompletionStatus[selectedSeason]!.add(false);
      taskController.clear();
      saveGardenSpaces();
      notifyListeners();
    }
  }

  void togglePlantCompletionStatus(int idx) {
    // Toggle the completion status of the plant at given index
    currentGardenSpace.plantCompletionStatus[selectedSeason]![idx] = 
      !currentGardenSpace.plantCompletionStatus[selectedSeason]![idx];
    saveGardenSpaces();
    notifyListeners();
  }

  void toggleTaskCompletionStatus(int idx) {
    // Toggle the completion status of a task
    currentGardenSpace.taskCompletionStatus[selectedSeason]![idx] = 
      !currentGardenSpace.taskCompletionStatus[selectedSeason]![idx];
    saveGardenSpaces();
    notifyListeners();
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