import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const WarehouseApp());
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý kho hàng',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
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
      appBar: AppBar(title: const Text('Quản lý kho hàng')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              title: 'Khai báo sản phẩm',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const UpdateStockScreen(isImport: true),
                  ),
                );
              },
            ),
            MenuButton(
              title: 'Xuất hàng',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const UpdateStockScreen(isImport: false),
                  ),
                );
              },
            ),
            MenuButton(
              title: 'Kho hàng',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WarehouseScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Lưu Phúc Khang - 22119188',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget cho các nút Menu
class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 250,
      child: ElevatedButton(onPressed: onPressed, child: Text(title)),
    );
  }
}

// Model lưu sản phẩm
class Product {
  String name;
  String origin;
  int quantity;

  Product({required this.name, required this.origin, required this.quantity});
}

List<Product> warehouse = [];

/// Khai báo sản phẩm
class DeclareProductScreen extends StatefulWidget {
  const DeclareProductScreen({super.key});

  @override
  State<DeclareProductScreen> createState() => _DeclareProductScreenState();
}

class _DeclareProductScreenState extends State<DeclareProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  String? qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khai báo sản phẩm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập thông tin sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên sản phẩm',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: originController,
              decoration: const InputDecoration(
                labelText: 'Nơi sản xuất',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Số lượng',
                prefixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  String name = nameController.text;
                  String origin = originController.text;
                  int quantity = int.tryParse(quantityController.text) ?? 0;
                  if (name.isNotEmpty && origin.isNotEmpty && quantity > 0) {
                    setState(() {
                      warehouse.add(
                        Product(name: name, origin: origin, quantity: quantity),
                      );
                      qrData =
                          'Tên: $name\nNơi sản xuất: $origin\nSố lượng: $quantity';
                    });
                  }
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Tạo QR Code và lưu'),
              ),
            ),
            const SizedBox(height: 20),
            if (qrData != null)
              Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: QrImageView(
                      data: qrData!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Nhập hoặc Xuất hàng
class UpdateStockScreen extends StatefulWidget {
  final bool isImport;

  const UpdateStockScreen({super.key, required this.isImport});

  @override
  State<UpdateStockScreen> createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isImport ? 'Nhập hàng' : 'Xuất hàng')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                int qty = int.tryParse(quantityController.text) ?? 0;
                Product? product = warehouse.firstWhere(
                  (p) => p.name == name,
                  orElse: () => Product(name: '', origin: '', quantity: 0),
                );

                if (product.name.isNotEmpty && qty > 0) {
                  setState(() {
                    if (widget.isImport) {
                      product.quantity += qty;
                    } else {
                      product.quantity =
                          (product.quantity - qty) >= 0
                              ? (product.quantity - qty)
                              : 0;
                    }
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Đã cập nhật kho.')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không tìm thấy sản phẩm.')),
                  );
                }
              },
              child: const Text('Cập nhật kho'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Xem kho hàng
class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kho hàng')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: warehouse.length,
          itemBuilder: (context, index) {
            final product = warehouse[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    product.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Nơi SX: ${product.origin}\nSL: ${product.quantity}',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
