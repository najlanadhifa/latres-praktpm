// list resto
class Restaurant {
  final String? id;
  final String? name;
  final String? description;
  final String? pictureId;
  final String? city;
  final double? rating;
  final String? address;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
    this.address,
  });

  // convert dari json ke object
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num?)?.toDouble(),
      address: json['address'],
    );
  }

  // convert dari object ke json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
      'address': address,
    };
  }
}

// response buat list resto
class RestaurantListResponse {
  final bool? error;
  final String? message;
  final int? count;
  final List<Restaurant>? restaurants;

  RestaurantListResponse({
    this.error,
    this.message,
    this.count,
    this.restaurants,
  });

  // convert dari json ke object
  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => Restaurant.fromJson(e))
          .toList(),
    );
  }
}

// detail resto
class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  // final List<Category> categories;
  // final Menus menus;
  final double rating;
  // final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    // required this.categories,
    // required this.menus,
    required this.rating,
    // required this.customerReviews,
  });

  // convert dari json ke object
  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      // categories: List<Category>.from(
      //     json["categories"].map((x) => Category.fromJson(x))),
      // menus: Menus.fromJson(json["menus"]),
      rating: (json["rating"] as num).toDouble(),
      // customerReviews: List<CustomerReview>.from(
      //     json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
    );
  }
}

// response buat detail
class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  // convert dari json ke object
  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantDetail.fromJson(json["restaurant"]),
    );
  }
}

// kategori makanan/minuman
// class Category {
//   final String name;

//   Category({required this.name});

//   // convert dari json ke object
//   factory Category.fromJson(Map<String, dynamic> json) =>
//       Category(name: json["name"]);
// }

// // data menu (foods & drinks)
// class Menus {
//   final List<Category> foods;
//   final List<Category> drinks;

//   Menus({required this.foods, required this.drinks});

//   // convert dari json ke object
//   factory Menus.fromJson(Map<String, dynamic> json) => Menus(
//         foods:
//             List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
//         drinks: List<Category>.from(
//             json["drinks"].map((x) => Category.fromJson(x))),
//       );
// }

// // data review customer
// class CustomerReview {
//   final String name;
//   final String review;
//   final String date;

//   CustomerReview({
//     required this.name,
//     required this.review,
//     required this.date,
//   });

//   // convert dari json ke object
//   factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
//         name: json["name"],
//         review: json["review"],
//         date: json["date"],
//       );
// }
