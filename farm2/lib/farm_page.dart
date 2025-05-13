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
      appBar: AppBar(
        title: const Text('Trang trại'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.grass, color: Colors.green, size: 60),
                const SizedBox(height: 12),
                const Text(
                  'Quản lý Trang trại',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn chức năng để bắt đầu',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 28),
                _FarmMenuButton(
                  icon: Icons.add_circle,
                  label: 'Khai báo giống cây',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FarmDeclarePage(),
                        ),
                      ),
                ),
                const SizedBox(height: 18),
                _FarmMenuButton(
                  icon: Icons.track_changes,
                  label: 'Theo dõi giống cây',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FarmTrackPage(),
                        ),
                      ),
                ),
                const SizedBox(height: 18),
                _FarmMenuButton(
                  icon: Icons.agriculture,
                  label: 'Thu hoạch',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FarmHarvestPage(),
                        ),
                      ),
                ),
                const SizedBox(height: 18),
                _FarmMenuButton(
                  icon: Icons.settings,
                  label: 'Quản lý trang trại',
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FarmInfo()),
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

class _FarmMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FarmMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        onPressed: onTap,
      ),
    );
  }
}
