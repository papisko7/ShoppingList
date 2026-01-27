class ShoppingListItem {
  final int id;
  final int productId;
  final String productName;
  final String categoryName;
  final String quantity;
  final bool isBought;

  ShoppingListItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.quantity,
    required this.isBought,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      categoryName: json['categoryName'] ?? '',
      quantity: json['quantity'] ?? '',
      isBought: json['isBought'],
    );
  }
}
