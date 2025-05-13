import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

import 'main.dart'; // Để dùng Product và warehouse chung

class DeclareProductScreen extends StatefulWidget {
  const DeclareProductScreen({super.key});

  @override
  State<DeclareProductScreen> createState() => _DeclareProductScreenState();
}

class _DeclareProductScreenState extends State<DeclareProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); 
  final TextEditingController quantityController = TextEditingController();

  String? productId;
  String? qrData;

  void declareProduct() {
    String name = nameController.text.trim();
    String date = dateController.text.trim();
    int quantity = int.tryParse(quantityController.text) ?? 0;

    if (name.isEmpty || date.isEmpty || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin hợp lệ!')),
      );
      return;
    }

    bool exists = warehouse.any(
      (p) => p.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã tồn tại trong kho!')),
      );
      return;
    }

    String id =
        'SP${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(1000)}';

    setState(() {
      productId = id;
      qrData = id;
      warehouse.add(
        Product(id: id, name: name, origin: date, quantity: quantity),
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Khai báo thành công!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khai báo sản phẩm'),
        backgroundColor: Color.fromARGB(255, 161, 249, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Khai báo sản phẩm mới',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    prefixIcon: Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Ngày sản xuất',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: declareProduct,
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Khai báo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 161, 249, 255),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (qrData != null) ...[
                  const SizedBox(height: 20),
                  QrImageView(
                    data: qrData!,
                    version: QrVersions.auto,
                    size: 140.0,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: $productId',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}