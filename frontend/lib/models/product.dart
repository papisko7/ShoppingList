class Product {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
    );
  }
}
