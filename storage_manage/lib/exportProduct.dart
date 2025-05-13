import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'main.dart';

class ExportProductScreen extends StatefulWidget {
  const ExportProductScreen({super.key});

  @override
  State<ExportProductScreen> createState() => _ExportProductScreenState();
}

class _ExportProductScreenState extends State<ExportProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  Product? foundProduct;
  bool scanning = false;

  void findProductByName() {
    String name = nameController.text.trim().toLowerCase();
    foundProduct = warehouse.firstWhere(
      (p) => p.name.toLowerCase() == name,
      orElse: () => Product(id: '', name: '', origin: '', quantity: 0),
    );
    if (foundProduct!.id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không tìm thấy sản phẩm!')));
      setState(() => foundProduct = null);
    } else {
      setState(() {});
    }
  }

  void onDetectBarcode(BarcodeCapture barcode) {
    final code = barcode.barcodes.first.rawValue ?? '';
    foundProduct = warehouse.firstWhere(
      (p) => p.id == code,
      orElse: () => Product(id: '', name: '', origin: '', quantity: 0),
    );
    if (foundProduct!.id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không tìm thấy sản phẩm!')));
      setState(() => foundProduct = null);
    } else {
      setState(() => scanning = false);
    }
  }

  void exportQuantity() {
    int qty = int.tryParse(quantityController.text) ?? 0;
    if (foundProduct == null || qty <= 0 || foundProduct!.quantity < qty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Số lượng không hợp lệ!')));
      return;
    }
    setState(() {
      foundProduct!.quantity -= qty;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xuất $qty sản phẩm ${foundProduct!.name}')),
    );
    quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xuất hàng'),
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
                  'Xuất bớt số lượng sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                if (scanning)
                  SizedBox(
                    height: 250,
                    child: MobileScanner(onDetect: onDetectBarcode),
                  ),
                if (!scanning) ...[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nhập tên sản phẩm',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: findProductByName,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => scanning = true),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Quét mã vạch/mã QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 161, 249, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (foundProduct != null)
                  Card(
                    child: ListTile(
                      title: Text(foundProduct!.name),
                      subtitle: Text(
                        'Ngày SX: ${foundProduct!.origin}\nSố lượng: ${foundProduct!.quantity}',
                      ),
                    ),
                  ),
                if (foundProduct != null) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Số lượng xuất',
                      prefixIcon: Icon(Icons.remove),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: exportQuantity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 161, 249, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Xuất hàng'),
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
