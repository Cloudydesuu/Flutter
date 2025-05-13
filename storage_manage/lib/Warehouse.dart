import 'package:flutter/material.dart';
import 'main.dart'; // Để dùng Product và warehouse

class WarehouseViewScreen extends StatefulWidget {
  const WarehouseViewScreen({super.key});

  @override
  State<WarehouseViewScreen> createState() => _WarehouseViewScreenState();
}

class _WarehouseViewScreenState extends State<WarehouseViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách kho hàng'),
        backgroundColor: const Color.fromARGB(255, 161, 249, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: warehouse.isEmpty
          ? const Center(child: Text('Kho hàng trống!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: warehouse.length,
              itemBuilder: (context, index) {
                final product = warehouse[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2, color: Colors.blueAccent),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Ngày SX: ${product.origin}\nSố lượng: ${product.quantity}'),
                    trailing: product.quantity == 0
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                warehouse.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã xóa sản phẩm ${product.name}')),
                              );
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}