import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classic Clock',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'Classic Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  String _selectedTimeZone = 'Asia/Ho_Chi_Minh';

  final List<String> _timeZones = [
    'Asia/Ho_Chi_Minh', // Vietnam
    'America/New_York', // America
    'Asia/Tokyo', // Japan
    'Asia/Shanghai', // China
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final location = tz.getLocation(_selectedTimeZone);
    setState(() {
      _currentTime = tz.TZDateTime.now(location);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline), // "!" icon
            onPressed: _showNameDialog, // Show dialog when clicked
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Time Zone Dropdown
          DropdownButton<String>(
            value: _selectedTimeZone,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedTimeZone = value;
                  _updateTime();
                });
              }
            },
            items:
                _timeZones.map((zone) {
                  return DropdownMenuItem(
                    value: zone,
                    child: Text(
                      _getCountryName(zone),
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          // Analog Clock
          Center(
            child: CustomPaint(
              size: const Size(300, 300),
              painter: ClockPainter(_currentTime),
            ),
          ),
          const SizedBox(height: 20),
          // Digital Clock
          Text(
            '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About Me'),
          content: const Text('Name: Luu Phuc Khang - 22119188'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getCountryName(String timeZone) {
    switch (timeZone) {
      case 'Asia/Ho_Chi_Minh':
        return 'Vietnam';
      case 'America/New_York':
        return 'America';
      case 'Asia/Tokyo':
        return 'Japan';
      case 'Asia/Shanghai':
        return 'China';
      default:
        return 'Unknown';
    }
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Paint for clock face
    final paintCircle =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    // Paint for clock border
    final paintBorder =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    // Paint for hour, minute, and second hands
    final paintHourHand =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final paintMinuteHand =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final paintSecondHand =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Draw clock face
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // Draw numbers on the clock
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (int i = 1; i <= 12; i++) {
      final angle = i * 30 * pi / 180;
      final numberOffset = Offset(
        center.dx + (radius * 0.8) * sin(angle),
        center.dy - (radius * 0.8) * cos(angle),
      );

      textPainter.text = TextSpan(
        text: i.toString(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          numberOffset.dx - textPainter.width / 2,
          numberOffset.dy - textPainter.height / 2,
        ),
      );
    }

    // Draw hour hand
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * pi / 180;
    final hourHandLength = radius * 0.5;
    final hourHandOffset = Offset(
      center.dx + hourHandLength * sin(hourAngle),
      center.dy - hourHandLength * cos(hourAngle),
    );
    canvas.drawLine(center, hourHandOffset, paintHourHand);

    // Draw minute hand
    final minuteAngle = (time.minute + time.second / 60) * 6 * pi / 180;
    final minuteHandLength = radius * 0.7;
    final minuteHandOffset = Offset(
      center.dx + minuteHandLength * sin(minuteAngle),
      center.dy - minuteHandLength * cos(minuteAngle),
    );
    canvas.drawLine(center, minuteHandOffset, paintMinuteHand);

    // Draw second hand
    final secondAngle = time.second * 6 * pi / 180;
    final secondHandLength = radius * 0.9;
    final secondHandOffset = Offset(
      center.dx + secondHandLength * sin(secondAngle),
      center.dy - secondHandLength * cos(secondAngle),
    );
    canvas.drawLine(center, secondHandOffset, paintSecondHand);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
