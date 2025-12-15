import 'package:dash_kit_core/dash_kit_core.dart';

class Product {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final Category category;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      // Map the List<dynamic> from JSON to List<String>
      images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  factory Product.empty() {
    // Return a Product instance with safe default values
    // NOTE: Replace these with your actual Product class structure
    return Product(
      id: -1,
      title: 'Loading...',
      slug: '',
      price: 0,
      description: 'Loading product details...',
      category: Category.empty(),
      images: [],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;
  final String slug;

  Category({required this.id, required this.name, required this.image, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      slug: json['slug'] as String,
    );
  }

  factory Category.empty() {
    // Return a Category instance with safe default values
    return Category(id: -1, name: 'Loading', image: '', slug: '');
  }
}
