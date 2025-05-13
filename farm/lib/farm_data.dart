class FarmProduct {
  final String id;
  final String name;
  final String date;
  final String unit;
  List<Map<String, String>> tracking = []; // Lưu thông tin theo dõi

  FarmProduct({
    required this.id,
    required this.name,
    required this.date,
    required this.unit,
  });
}

class FarmData {
  static final List<FarmProduct> declaredProducts = [];

  // Thêm phương thức này để xóa sản phẩm theo id
  static void removeProductById(String id) {
    declaredProducts.removeWhere((product) => product.id == id);
  }
}
