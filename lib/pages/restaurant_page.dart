import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../services/restaurant_service.dart';
import '../services/auth_service.dart';
import 'restaurant_detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<Restaurant> restaurants = []; // buat nyimpen list resto
  bool isLoading = true; 
  String? username; // nyimpen username 

  @override
  void initState() {
    super.initState();
    _loadData(); 
  }

  Future<void> _loadData() async {
    await _loadUsername(); // ambil nama user
    await _loadRestaurants(); // ambil data resto
  }

  Future<void> _loadUsername() async {
    final currentUsername = await AuthService.getCurrentUsername();
    setState(() {
      username = currentUsername; // simpen username ke state
    });
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      isLoading = true; 
    });

    final response = await RestaurantService.getRestaurants();
    setState(() {
      restaurants = response?.restaurants ?? []; // isi list resto
      isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF502314),
        elevation: 0,
        title: Text(
          'Halo, ${username ?? 'User'}', 
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // buka halaman favorit
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(); 
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Color(0xFF1D2B64)),
                    SizedBox(width: 8),
                    Text('Keluar'), // tombol keluar
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFC72C), 
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white), 
              )
            : RefreshIndicator(
                color: const Color(0xFF1D2B64),
                backgroundColor: Colors.white.withOpacity(0.7),
                onRefresh: _loadRestaurants, // buat refresh data
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return _buildRestaurantCard(restaurant); // bikin card resto
                  },
                ),
              ),
      ),
    );
  }

  // widget buat card resto
  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), 
      ),
      color: Colors.white.withOpacity(0.9), 
      child: InkWell(
        onTap: () {
          // ke detail klo diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RestaurantDetailPage(restaurantId: restaurant.id!),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 130,
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(24)),
                child: Image.network(
                  RestaurantService.getImageUrl(restaurant.pictureId!),
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // klo gambar error, tampilin ikon error
                    return Container(
                      width: 130,
                      height: 130,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, color: Colors.grey),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        restaurant.name ?? '', // nama resto
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              restaurant.city ?? '', 
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            restaurant.rating?.toStringAsFixed(1) ?? '0.0', 
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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

  // fungsi logout
  Future<void> _logout() async {
    await AuthService.logout(); // hapus session
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(), // balik ke login
      ),
    );
  }
}