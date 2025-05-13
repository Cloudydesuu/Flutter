import 'package:flutter/material.dart';
import 'farm_data.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FarmTrackPage extends StatefulWidget {
  const FarmTrackPage({super.key});

  @override
  State<FarmTrackPage> createState() => _FarmTrackPageState();
}

class _FarmTrackPageState extends State<FarmTrackPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController fertilizerController = TextEditingController();
  final TextEditingController careController = TextEditingController();

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

  void _saveTracking() {
    if (selectedProduct != null) {
      selectedProduct!.tracking.add({
        'date': DateTime.now().toString(),
        'fertilizer': fertilizerController.text,
        'care': careController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thông tin theo dõi!')),
      );
      fertilizerController.clear();
      careController.clear();
    }
  }

  Future<void> _scanQR(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(title: const Text('Quét QR')),
              body: MobileScanner(
                onDetect: (capture) {
                  final barcode = capture.barcodes.first;
                  Navigator.pop(context, barcode.rawValue);
                },
              ),
            ),
      ),
    );
    if (result != null && result is String && result.isNotEmpty) {
      idController.text = result;
      _findProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi giống cây')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            selectedProduct == null
                ? Column(
                  children: [
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Nhập ID sản phẩm',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _findProduct,
                          child: const Text('Tìm sản phẩm'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _scanQR(context),
                          child: const Text('Quét QR'),
                        ),
                      ],
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tên giống: ${selectedProduct!.name}'),
                    Text('Ngày trồng: ${selectedProduct!.date}'),
                    Text('Đơn vị: ${selectedProduct!.unit}'),
                    const Divider(),
                    TextField(
                      controller: fertilizerController,
                      decoration: const InputDecoration(
                        labelText: 'Loại phân bón',
                      ),
                    ),
                    TextField(
                      controller: careController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả chăm sóc',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveTracking,
                      child: const Text('Lưu theo dõi'),
                    ),
                  ],
                ),
      ),
    );
  }
}
