// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:garden_app/Models/garden_app_state.dart';



// Add in place to add gardens/spaces, with separate, seasonal task and plant lists instead of one plant and task list for each season

// class GardenSpace extends StatelessWidget {
// // For defining different garden spaces with separate plant and task lists
// @override
// Widget build (BuildContext context) {
//   var gardenAppState = Provider.of<GardenAppState>(context);
//   ThemeData theme = Theme.of(context);

//   return Column(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               color: theme.colorScheme.primary,
//               width: 3.0,
//             ),
//             bottom: BorderSide(
//               color: theme.colorScheme.primary,
//               width: 3.0,
//             ),
//           ),
//         ),
//         child: Text(
//           season,
//           style: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onBackground,
//           ),
//         ),
//       ),
//       SizedBox(height: 10),
//       PlantList(onAddPlant: onAddPlant),
//     ],
//   );
// }

// }

