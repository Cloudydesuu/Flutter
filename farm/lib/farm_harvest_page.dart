import 'package:flutter/material.dart';

class FarmHarvestPage extends StatelessWidget {
  const FarmHarvestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Thu hoạch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên giống cây'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Ngày thu hoạch'),
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Tổng trọng lượng'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Giá trên đơn vị'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Xác nhận & Tạo QR'),
              onPressed: () {
                // TODO: Lưu thông tin thu hoạch và tạo QR
              },
            ),
          ],
        ),
      ),
    );
  }
}
