import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'farm_data.dart';

class FarmDeclarePage extends StatefulWidget {
  const FarmDeclarePage({super.key});

  @override
  State<FarmDeclarePage> createState() => _FarmDeclarePageState();
}

class _FarmDeclarePageState extends State<FarmDeclarePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  String? generatedId;
  bool showQR = false;

  void _saveAndGenerateQR() {
    if (nameController.text.isEmpty ||
        dateController.text.isEmpty ||
        unitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }
    final id = const Uuid().v4();
    setState(() {
      generatedId = id;
      showQR = true;
    });
    // Lưu thông tin vào list
    FarmData.declaredProducts.add(
      FarmProduct(
        id: id,
        name: nameController.text,
        date: dateController.text,
        unit: unitController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khai báo giống cây')),
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
              decoration: const InputDecoration(
                labelText: 'Ngày trồng (yyyy-mm-dd)',
              ),
              // Cho phép nhập tay, không cần readOnly và onTap
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Đơn vị trồng'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAndGenerateQR,
              child: const Text('Lưu & Tạo QR'),
            ),
            if (showQR && generatedId != null) ...[
              const SizedBox(height: 20),
              Text('Mã sản phẩm: $generatedId'),
              QrImageView(
                data: generatedId!,
                version: QrVersions.auto,
                size: 180.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
