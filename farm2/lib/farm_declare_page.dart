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
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _saveAndGenerateQR() async {
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
    // Lưu vào Hive
    await FarmData.addProduct(
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
      appBar: AppBar(
        title: const Text('Khai báo giống cây'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_circle, color: Colors.green, size: 48),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên giống cây',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.eco),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: 'Ngày trồng (dd/mm/yyyy)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: 'Đơn vị trồng',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveAndGenerateQR,
                  icon: const Icon(Icons.qr_code, color: Colors.white),
                  label: const Text(
                    'Lưu & Tạo QR',
                    style: TextStyle(
                      color: Colors.white, // Đổi màu chữ thành trắng
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (showQR && generatedId != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Mã sản phẩm: $generatedId',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: generatedId!,
                    version: QrVersions.auto,
                    size: 180.0,
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
