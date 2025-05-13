import 'package:flutter/material.dart';

class ConsumerPage extends StatelessWidget {
  const ConsumerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Người tiêu dùng')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Quét mã QR sản phẩm'),
          onPressed: () {
            // TODO: Thêm chức năng quét QR
          },
        ),
      ),
    );
  }
}
