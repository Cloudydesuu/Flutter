import 'package:flutter/material.dart';
import 'farm_data.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FarmTrackPage extends StatefulWidget {
  const FarmTrackPage({super.key});

  @override
  State<FarmTrackPage> createState() => _FarmTrackPageState();
}

class _FarmTrackPageState extends State<FarmTrackPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController fertilizerController = TextEditingController();
  final TextEditingController careController = TextEditingController();
  DateTime? selectedDate;
  File? proofImage;

  FarmProduct? selectedProduct;

  void _findProduct() {
    final id = idController.text.trim();
    final found = FarmData.declaredProducts.where((e) => e.id == id).toList();
    if (found.isNotEmpty) {
      setState(() {
        selectedProduct = found.first;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy sản phẩm với ID này!')),
      );
    }
  }

  void _saveTracking() async {
    if (selectedProduct != null) {
      selectedProduct!.addTracking({
        'date': (selectedDate ?? DateTime.now()).toString(),
        'fertilizer': fertilizerController.text,
        'care': careController.text,
        'proofImage': proofImage?.path,
      });
      await FarmData.addProduct(selectedProduct!); // Lưu lại vào Hive
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thông tin theo dõi!')),
      );
      fertilizerController.clear();
      careController.clear();
      setState(() {
        proofImage = null;
        selectedDate = null;
      });
    }
  }

  Widget _buildIdInput(BuildContext context) {
    return TextField(
      controller: idController,
      decoration: InputDecoration(
        labelText: 'Nhập ID sản phẩm',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.qr_code),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _findProduct,
          tooltip: 'Tìm sản phẩm',
        ),
      ),
    );
  }

  Future<void> _scanQR(BuildContext context) async {
    String? result;
    bool scanned = false;
    result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(title: const Text('Quét QR')),
              body: MobileScanner(
                onDetect: (capture) {
                  if (!scanned && capture.barcodes.isNotEmpty) {
                    scanned = true;
                    final barcode = capture.barcodes.first;
                    Navigator.pop(context, barcode.rawValue);
                  }
                },
              ),
            ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      idController.text = result;
      _findProduct();
    }
  }

  Future<void> _pickProofImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        proofImage = File(picked.path);
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo dõi giống cây'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            selectedProduct == null
                ? Column(
                  children: [
                    _buildIdInput(context),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _scanQR(context),
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        label: const Text(
                          'Quét QR',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                )
                : Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.eco,
                            color: Colors.green,
                            size: 40,
                          ),
                          title: Text(
                            selectedProduct!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          subtitle: Text('ID: ${selectedProduct!.id}'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          title: Text('Ngày trồng: ${selectedProduct!.date}'),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.straighten,
                            color: Colors.orange,
                          ),
                          title: Text('Đơn vị: ${selectedProduct!.unit}'),
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: () => _pickDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Ngày lưu minh chứng',
                                hintText: 'Chọn ngày',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.date_range),
                              ),
                              controller: TextEditingController(
                                text:
                                    selectedDate != null
                                        ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                                        : '',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: fertilizerController,
                          decoration: InputDecoration(
                            labelText: 'Loại phân bón',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.local_florist),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: careController,
                          decoration: InputDecoration(
                            labelText: 'Mô tả chăm sóc',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.description),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickProofImage,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Chụp minh chứng'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (proofImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                proofImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _saveTracking,
                            icon: const Icon(Icons.save),
                            label: const Text('Lưu theo dõi'),
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
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
