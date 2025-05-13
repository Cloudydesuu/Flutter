import 'package:flutter/material.dart';
import 'farm_data.dart';

class FarmInfo extends StatefulWidget {
  const FarmInfo({super.key});

  @override
  State<FarmInfo> createState() => _FarmInfoState();
}

class _FarmInfoState extends State<FarmInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kho cây đang trồng')),
      body: ListView.builder(
        itemCount: FarmData.declaredProducts.length,
        itemBuilder: (context, index) {
          final crop = FarmData.declaredProducts[index];
          return ListTile(
            leading: const Icon(Icons.local_florist),
            title: Text(crop.name),
            subtitle: Text('Ngày trồng: ${crop.date} - Đơn vị: ${crop.unit}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  FarmData.removeProductById(crop.id);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
