import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'farm_data.dart';

class FarmHarvestPage extends StatefulWidget {
  const FarmHarvestPage({super.key});

  @override
  State<FarmHarvestPage> createState() => _FarmHarvestPageState();
}

class _FarmHarvestPageState extends State<FarmHarvestPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  FarmProduct? selectedProduct;
  DateTime? selectedPlantDate;

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
        labelText: 'Nhập ID cây trồng',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.qr_code),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _findProduct,
          tooltip: 'Tìm cây trồng',
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
    if (!mounted) return; // Thêm dòng này để tránh lỗi context sau async
    if (result != null && result.isNotEmpty) {
      idController.text = result;
      _findProduct();
    }
  }

  void _confirmHarvest() async {
    if (selectedProduct != null) {
      selectedProduct!.harvestDate = DateTime.now().toString();
      selectedProduct!.harvestWeight = double.tryParse(weightController.text);
      selectedProduct!.pricePerKg = int.tryParse(priceController.text);
      await FarmData.addProduct(selectedProduct!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xác nhận thu hoạch!')));
      setState(() {
        selectedProduct = null;
        idController.clear();
        weightController.clear();
        priceController.clear();
      });
    }
  }

  void _rejectHarvest() {
    setState(() {
      selectedProduct = null;
      idController.clear();
    });
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _pickPlantDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedPlantDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedPlantDate = picked;
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thu hoạch'),
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
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Quét QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                        GestureDetector(
                          onTap: () => _pickPlantDate(context),
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
                        ListTile(
                          leading: const Icon(
                            Icons.straighten,
                            color: Colors.orange,
                          ),
                          title: Text('Đơn vị: ${selectedProduct!.unit}'),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.green,
                          ),
                          title: Text(
                            'Ngày thu hoạch: ${selectedProduct!.harvestDate != null ? _formatDate(selectedProduct!.harvestDate!) : "Chưa thu hoạch"}',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Trọng lượng thu hoạch (kg)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.scale),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Giá thành (VNĐ/kg)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _confirmHarvest,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Xác nhận thu hoạch'),
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
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _rejectHarvest,
                            icon: const Icon(Icons.cancel),
                            label: const Text('Từ chối'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
