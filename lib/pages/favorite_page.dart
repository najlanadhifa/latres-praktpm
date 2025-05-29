import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../services/favorite_service.dart';
import '../services/restaurant_service.dart';
import 'restaurant_detail_page.dart';

// halaman buat nampilin list restoran favorit user
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Restaurant> favoriteRestaurants = []; // simpen data favorit
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    final favorites =
        await FavoritesService.getFavorites(); // ambil data dari service
    setState(() {
      favoriteRestaurants = favorites;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorit Restaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF502314),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFC72C),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : favoriteRestaurants.isEmpty
                ? Center(
                    child: Column(
                      // klo kosong, tampilin icon + teks
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum punya restoran favorit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadFavorites, // buat refresh manual
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: favoriteRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = favoriteRestaurants[index];
                        return _buildFavoriteCard(
                            restaurant); // build kartu satu"
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildFavoriteCard(Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailPage(
                  restaurantId: restaurant.id!), // ke page detail
            ),
          );
          _loadFavorites(); // refresh data abis balik dari detail
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
                child: Image.network(
                  RestaurantService.getImageUrl(
                      restaurant.pictureId!), // gambar resto
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey), // klo gagal load gambar
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name ?? '', // nama resto
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              restaurant.city ?? '', // kota
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Color(0xFFFBBF24)),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating?.toStringAsFixed(1) ??
                                '0.0', // rating resto
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
