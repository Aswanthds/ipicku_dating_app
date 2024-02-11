import 'package:ipicku_dating_app/data/repositories/matches_repo.dart';

class CheckFunctions {
  static Future<bool> isMutualPick(String selectedId) async {
    final dataMutual = await MatchesRepository().getMutualList();

    for (var data in dataMutual) {
      return data.containsValue(selectedId);
    }
    return false;
  }
}
