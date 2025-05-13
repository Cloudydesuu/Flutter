import 'package:flutter/material.dart';
import 'farm_declare_page.dart';
import 'farm_track_page.dart';
import 'farm_harvest_page.dart';
import 'farm_info.dart';

class FarmPage extends StatelessWidget {
  const FarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang trại')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Khai báo giống cây'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmDeclarePage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Theo dõi giống cây'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmTrackPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Thu hoạch'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmHarvestPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Quản lý trang trại'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FarmInfo()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
