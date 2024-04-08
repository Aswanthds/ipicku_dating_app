

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class LoveCalculatorAPi {
  static double getlovePercentage(
      Map<String, dynamic> userDataA, Map<String, dynamic> userDataB) {
    try {
      debugPrint("$userDataA ");
      debugPrint("$userDataB");
      String nameA = userDataA['name'];
      int ageA = userDataA['age'];
      var chatTimeA = userDataA['lastActive'] as Timestamp;
      var commonPreferencesA = userDataA['preferences'] ?? [];

      String nameB = userDataB['name'];
      int ageB = userDataB['age'];
      var chatTimeB = userDataB['lastActive'] as Timestamp;
      var commonPreferencesB = userDataB['preferences'] ?? [];

      // Calculate age range
      int minAge = ageA < ageB ? ageA : ageB;
      int maxAge = minAge + 6;

      // Calculate age difference
      int ageDifference = (ageA - ageB).abs();

      // Calculate love percentage for both users
      double percentageA = calculatePercentageOfLove(
          minAge, maxAge, chatTimeA, commonPreferencesA, ageDifference);
      double percentageB = calculatePercentageOfLove(
          minAge, maxAge, chatTimeB, commonPreferencesB, ageDifference);

      // Calculate average percentage of love
      double averagePercentage = (percentageA + percentageB) / 2;

      // Display the result
      debugPrint(
          "\nLove Percentage between $nameA and $nameB is: $averagePercentage%");

      return averagePercentage;
    } catch (e) {
      debugPrint(e.toString());
      return 0.0;
    }
  }

  static double calculatePercentageOfLove(int minAge, int maxAge,
      Timestamp chatTime, List<dynamic> commonPreferences, int ageDifference) {
    // Calculate age range
    maxAge = minAge + 6;

    // Adjust age range if it exceeds 25
    if (maxAge > 25) {
      maxAge = 25;
    }

    // Calculate love percentage based on factors
    double ageFactor = 1 - (ageDifference / 25); // Normalize age difference
    double preferenceFactor =
        commonPreferences.length / 10; // Normalize common preferences
    double timeFactor = chatTime.seconds /
        86400; // Normalize chat time (considering a day as unit)

    // Calculate overall love percentage considering all factors
    double percentage = (ageFactor + preferenceFactor + timeFactor) / 3 * 100;

    // Ensure the percentage is within 0 to 100
    return percentage.clamp(0, 100).toDouble();
  }
}
