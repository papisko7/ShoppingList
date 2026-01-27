import 'package:flutter/material.dart';

class CategoriesSelectionProvider extends ChangeNotifier {
  int? selectedCategoryId;

  void select(int categoryId) {
    selectedCategoryId = categoryId;
    notifyListeners();
  }

  void clear() {
    selectedCategoryId = null;
    notifyListeners();
  }
}
