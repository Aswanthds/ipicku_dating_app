import 'dart:math';

class LoveCalculatorAPi {
  static int sumOfDigits(int num) {
    int sum = 0;
    while (num > 0) {
      sum += (num % 10);
      num ~/= 10; // Using integer division operator
    }
    return sum;
  }

  static double loveCalculator(
      Map<String, dynamic> userData1, Map<String, dynamic> userData2) {
    String yName = userData1['name'];
    String pName = userData2['name'];
    int yage = userData1['age'];
    int page = userData2['age'];

    int sum = 0;
    for (var rune in yName.runes) {
      sum += rune;
    }

    int sum1 = 0;
    for (var rune in pName.runes) {
      sum1 += rune;
    }

    int agediference = (yage - page).abs();

    double perc =
        (sumOfDigits(sum) + sumOfDigits(sum1) + sumOfDigits(agediference)) + 40;
    perc = min(perc, 100); // Ensure percentage doesn't exceed 100

    print('Your love percentage is: ${perc.toStringAsFixed(2)}');

    return perc.abs();
  }
}
