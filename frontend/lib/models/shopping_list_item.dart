class ShoppingListItem {
  final int id;
  final bool isBought;
  final int productId;
  final String productName;
  final String quantity;

  ShoppingListItem({
    required this.id,
    required this.isBought,
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      isBought: json['isBought'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
    );
  }
}
