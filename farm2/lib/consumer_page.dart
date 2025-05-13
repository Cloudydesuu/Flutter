import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'farm_data.dart';
import 'dart:io';

class ConsumerPage extends StatefulWidget {
  const ConsumerPage({super.key});

  @override
  State<ConsumerPage> createState() => _ConsumerPageState();
}

class _ConsumerPageState extends State<ConsumerPage> {
  final TextEditingController idController = TextEditingController();
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

  Widget _buildTrackingHistory(FarmProduct product) {
    final tracks = product.trackingList;
    if (tracks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Chưa có thông tin theo dõi nào.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Lịch sử theo dõi:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ),
        ...tracks.reversed.map((track) {
          final date = track['date'] ?? '';
          final fertilizer = track['fertilizer'] ?? '';
          final care = track['care'] ?? '';
          final imagePath = track['proofImage'];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngày: $date',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Phân bón: $fertilizer'),
                  Text('Chăm sóc: $care'),
                  if (imagePath != null && imagePath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Người tiêu dùng'),
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
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Quét QR'),
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
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
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
                              title: Text(
                                'Ngày trồng: ${selectedProduct!.date}',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.straighten,
                                color: Colors.orange,
                              ),
                              title: Text('Đơn vị: ${selectedProduct!.unit}'),
                            ),
                            if (selectedProduct!.harvestDate != null)
                              ListTile(
                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  'Ngày thu hoạch: ${selectedProduct!.harvestDate}',
                                ),
                              ),
                            if (selectedProduct!.harvestWeight != null)
                              Text(
                                'Trọng lượng thu hoạch: ${selectedProduct!.harvestWeight} kg',
                              ),
                            if (selectedProduct!.pricePerKg != null)
                              Text(
                                'Giá thành: ${selectedProduct!.pricePerKg} VNĐ/kg',
                              ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.search),
                                label: const Text('Tìm sản phẩm khác'),
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
                                onPressed: () {
                                  setState(() {
                                    selectedProduct = null;
                                    idController.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildTrackingHistory(selectedProduct!),
                  ],
                ),
      ),
    );
  }
}
