import 'package:flutter/material.dart';

import 'agoda_demo_screen.dart';

export 'agoda_demo_screen.dart';

/// Màn hình mẫu Câu 5 [1 điểm]:
/// Đáp ứng chính xác yêu cầu của giảng viên: Giao diện Agoda Homepage.
/// Đồng thời hỗ trợ chuyển đổi sang layout nút bấm mẫu nếu cần.
class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  bool _showAgodaScreen = true;

  @override
  Widget build(BuildContext context) {
    if (_showAgodaScreen) {
      return const AgodaDemoScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Màn hình mẫu Câu 5'),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showAgodaScreen = true),
            icon: const Icon(Icons.travel_explore),
            label: const Text('Xem mẫu Agoda'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.yellow,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã bấm Nút nhấn thứ 1')),
                  );
                },
                child: const Text('Nút nhấn thứ 1'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Có thể',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.yellow,
                  disabledBackgroundColor: Colors.red.withValues(alpha: 0.5),
                  disabledForegroundColor: Colors.yellow.withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onPressed: null,
                child: const Text('Nút nhấn thứ 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
