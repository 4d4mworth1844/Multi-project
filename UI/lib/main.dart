import 'package:flutter/material.dart';
import 'package:smartfarm/screens/automatic_settings.dart';
import 'package:smartfarm/screens/home.dart';
import 'package:smartfarm/screens/system_infomation.dart';
import 'package:smartfarm/widgets/new_schedule.dart';

void main() {
  runApp(const SmartApp());
}

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 174, 78),
    brightness: Brightness.light,
  ),
);

class SmartApp extends StatelessWidget {
  const SmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      // const Scaffold(body: NewSchedule()),
      // const AutomaticSettings(),
    );
  }
}
