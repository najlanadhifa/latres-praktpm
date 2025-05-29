import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';

class RestaurantService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  static Future<RestaurantListResponse?> getRestaurants() async {
    try {
      // ambil data list restoran dari api
      final response = await http.get(Uri.parse('$baseUrl/list'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RestaurantListResponse.fromJson(jsonData);
      }
      return null; // klo gagal, balikin null
    } catch (e) {
      print('Error fetching restaurants: $e');
      return null;
    }
  }

  static Future<RestaurantDetailResponse?> getRestaurantDetail(String id) async {
    try {
      // ambil detail restoran berdasarkan id
      final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RestaurantDetailResponse.fromJson(jsonData);
      }
      return null; // klo gagal, balikin null
    } catch (e) {
      print('Error fetching restaurant detail: $e');
      return null;
    }
  }

  static String getImageUrl(String pictureId) {
    // generate url gambar dari id gambar
    return '$baseUrl/images/small/$pictureId';
  }
}