import 'package:flutter/material.dart';
import 'DeclareProduct.dart';
import 'Warehouse.dart';
import 'importProduct.dart';
import 'exportProduct.dart';

void main() => runApp(const WarehouseApp()); 

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key}); // Kế

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý kho hàng',
      theme: ThemeData(),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý kho hàng'),
        backgroundColor: Color.fromARGB(255, 161, 249, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true, 
          padding: const EdgeInsets.all(24),
          children: [
            MenuButton(
              title: 'Khai báo sản phẩm',
              icon: Icons.add_box,
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeclareProductScreen(),
                  ),
                );
              },
            ),
            MenuButton(
              title: 'Nhập hàng',
              icon: Icons.inventory,
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImportProductScreen(),
                  ),
                );
              },
            ),
            MenuButton(
              title: 'Xuất hàng',
              icon: Icons.outbox,
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExportProductScreen(),
                  ),
                );
              },
            ),
            MenuButton(
              title: 'Kho hàng',
              icon: Icons.warehouse,
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WarehouseViewScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Lưu Phúc Khang - 22119188',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// Model lưu sản phẩm
class Product {
  String id;
  String name;
  String origin;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.origin,
    required this.quantity,
  });
}

List<Product> warehouse = [];

