import 'package:flutter/material.dart';
import 'package:garden_app/Widgets/plant_list.dart';


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

