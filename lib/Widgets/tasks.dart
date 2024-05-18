import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Models/garden_app_state.dart';

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
