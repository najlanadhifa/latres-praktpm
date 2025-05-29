import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../services/restaurant_service.dart';
import '../services/favorite_service.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String? restaurantId;

  const RestaurantDetailPage({
    Key? key,
    this.restaurantId,
  }) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  RestaurantDetail? restaurant;
  bool isLoading = true;
  bool isFavorite = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // kalo ada id restoran, load datanya
    if (widget.restaurantId != null) {
      _loadRestaurantDetail();
      _checkFavoriteStatus();
    } else {
      // kalo ga ada id, munculin error
      setState(() {
        isLoading = false;
        errorMessage = 'ID restoran tidak disediakan';
      });
    }
  }

  // ambil detail restoran
  Future<void> _loadRestaurantDetail() async {
    if (widget.restaurantId == null) return;

    setState(() => isLoading = true);

    final response =
        await RestaurantService.getRestaurantDetail(widget.restaurantId!);
    setState(() {
      restaurant = response?.restaurant;
      isLoading = false;
      if (response == null) {
        errorMessage = 'Gagal memuat rincian restoran';
      }
    });
  }

  // cek apakah restoran udah jadi favorit
  Future<void> _checkFavoriteStatus() async {
    if (widget.restaurantId == null) return;

    final favorite = await FavoritesService.isFavorite(widget.restaurantId!);
    setState(() {
      isFavorite = favorite;
    });
  }

  // toggle favorit on/off
  Future<void> _toggleFavorite() async {
    if (restaurant == null) return;

    if (isFavorite) {
      await FavoritesService.removeFromFavorites(restaurant!.id);
      setState(() => isFavorite = false);
      _showSnackbar('Dihapus dari favorit', Colors.red);
    } else {
      // bikin objek buat disimpan sbg favorit
      final restaurantForFavorite = Restaurant(
        id: restaurant!.id,
        name: restaurant!.name,
        description: restaurant!.description,
        pictureId: restaurant!.pictureId,
        city: restaurant!.city,
        rating: restaurant!.rating,
        address: restaurant!.address,
      );

      await FavoritesService.addToFavorites(restaurantForFavorite);
      setState(() => isFavorite = true);
      _showSnackbar('Ditambah ke favorit', Colors.green);
    }
  }

  // munculin snackbar info
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // loading
          : errorMessage != null
              ? Center( // error muncul
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kembali'),
                      ),
                    ],
                  ),
                )
              : restaurant == null
                  ? const Center(child: Text('Restaurant tidak ditemukan')) 
                  : CustomScrollView( 
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          backgroundColor: Color(0xFF502314),
                          iconTheme: const IconThemeData(color: Colors.white),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                              RestaurantService.getImageUrl(
                                  restaurant!.pictureId),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          actions: [
                            // icon favorit
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // nama restoran
                                Text(
                                  restaurant!.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // info lokasi
                                _buildInfoRow(Icons.location_on,
                                    '${restaurant!.city}, ${restaurant!.address}'),
                                const SizedBox(height: 8),
                                // rating
                                _buildInfoRow(Icons.star,
                                    restaurant!.rating.toStringAsFixed(1)),
                                const SizedBox(height: 16),
                                // deskripsi restoran
                                _buildSectionTitle('Deskripsi'),
                                Text(
                                  restaurant!.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // kategori
                                _buildSectionTitle('Kategori'),
                                Wrap(
                                  spacing: 8,
                                  children: restaurant!.categories
                                      .map((c) => Chip(label: Text(c.name)))
                                      .toList(),
                                ),
                                const SizedBox(height: 24),
                                // menu makanan & minuman
                                _buildSectionTitle('Menu'),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: _buildMenuList('Makanan',
                                            restaurant!.menus.foods)),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: _buildMenuList('Minuman',
                                            restaurant!.menus.drinks)),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // review dari pelanggan
                                _buildSectionTitle('Review'),
                                ...restaurant!.customerReviews
                                    .map((r) => _buildReviewCard(r)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  // widget utk info icon + teks
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF502314), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // judul section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
    );
  }

  // daftar menu
  Widget _buildMenuList(String title, List<Category> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.fastfood, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.name)),
                ],
              ),
            )),
      ],
    );
  }

  // card buat review
  Widget _buildReviewCard(CustomerReview review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF502314),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            review.review,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            review.date,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}