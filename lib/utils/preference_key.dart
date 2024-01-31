import '../main.dart';

class SharedpreferenceKey {
  static const String userId = 'userId';
  static const String firstTimeAppOpen = 'firstTimeAppOpen';
  static const String loggedIn = 'loggedIn';
  static const String favourite = 'favourite';

  static int getUserId() {
    return prefs.getInt(userId) ?? -1;
  }

  static Future<bool> addToFavourite(String id) {
    List<String> favIds = prefs.getStringList(favourite) ?? [];
    favIds.add(id);
    return prefs.setStringList(favourite, favIds);
  }

  static Future<bool> removeFromFavourite(String id) {
    List<String> favIds = prefs.getStringList(favourite) ?? [];
    favIds.remove(id);
    return prefs.setStringList(favourite, favIds);
  }

  static List<int> getAllFavIds() {
    List<String> favIds = prefs.getStringList(favourite) ?? [];

    return favIds.map((e) => int.parse(e)).toList();
  }
}
