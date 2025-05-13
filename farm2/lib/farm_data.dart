import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

part 'farm_data.g.dart';

@HiveType(typeId: 0)
class FarmProduct extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String date;
  @HiveField(3)
  String unit;
  @HiveField(4)
  List<String> tracking; // Lưu json string
  @HiveField(5)
  String? harvestDate;
  @HiveField(6)
  double? harvestWeight; // Thêm trọng lượng thu hoạch
  @HiveField(7)
  int? pricePerKg; // Thêm giá thành trên mỗi kg

  FarmProduct({
    required this.id,
    required this.name,
    required this.date,
    required this.unit,
    this.tracking = const [],
    this.harvestDate,
    this.harvestWeight,
    this.pricePerKg,
  });

  void addTracking(Map<String, dynamic> track) {
    tracking = [...tracking, jsonEncode(track)];
  }

  List<Map<String, dynamic>> get trackingList =>
      tracking.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
}

class FarmData {
  static late Box<FarmProduct> productBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FarmProductAdapter());
    productBox = await Hive.openBox<FarmProduct>('products');
  }

  static List<FarmProduct> get declaredProducts => productBox.values.toList();

  static Future<void> addProduct(FarmProduct product) async {
    await productBox.put(product.id, product);
  }

  static Future<void> removeProductById(String id) async {
    await productBox.delete(id);
  }
}
