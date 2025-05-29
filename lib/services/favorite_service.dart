import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  static Future<List<Restaurant>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];

    // ubah json jd list restaurant
    return favoritesJson
        .map((json) => Restaurant.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> addToFavorites(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    // cek klo belum ada di favorit
    if (!favorites.any((fav) => fav.id == restaurant.id)) {
      favorites.add(restaurant);

      // simpen list favorit ke storage
      final favoritesJson = favorites
          .map((restaurant) => jsonEncode(restaurant.toJson()))
          .toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  static Future<void> removeFromFavorites(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    // hapus yg id-nya sama
    favorites.removeWhere((restaurant) => restaurant.id == restaurantId);

    // update data favorit yg udah dihapus
    final favoritesJson =
        favorites.map((restaurant) => jsonEncode(restaurant.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  static Future<bool> isFavorite(String restaurantId) async {
    final favorites = await getFavorites();
    
    // cek ini restoran favorit apa bukan
    return favorites.any((restaurant) => restaurant.id == restaurantId);
  }
}