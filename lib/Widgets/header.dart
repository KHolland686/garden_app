import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/Models/garden_app_state.dart';

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