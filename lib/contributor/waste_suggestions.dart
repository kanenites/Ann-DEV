// waste_suggestions.dart
import 'dart:math';

class WasteMinimizationService {
  // List of suggestions for waste minimization
  final List<String> _suggestions = [
    "Consider donating excess food to local charities or food banks.",
    "Repurpose leftovers by incorporating them into new recipes.",
    "Plan your food purchases to reduce overbuying and waste.",
    "Use proper storage techniques to extend the life of perishable foods.",
    "Compost food scraps to reduce waste and nourish your garden.",
    "Freeze extra food items to keep them fresh for longer.",
    "Encourage customers to bring their own containers for takeout.",
    "Conduct regular inventory checks to minimize expired items.",
    "Prepare food in batches to reduce waste from small leftovers.",
    "Offer smaller portion sizes as options for customers.",
  ];

  // Function to get a suggestion based on weekly waste amount
  String getSuggestion(double weeklyWaste) {
    if (weeklyWaste <= 5) {
      return "You're doing great! Keep up the good work in reducing waste.";
    } else if (weeklyWaste > 5 && weeklyWaste <= 15) {
      return _suggestions[Random().nextInt(_suggestions.length)];
    } else if (weeklyWaste > 15 && weeklyWaste <= 30) {
      return "Consider optimizing portion sizes to reduce waste.";
    } else {
      return "High waste levels detected. Try reducing inventory or donating excess.";
    }
  }
}
