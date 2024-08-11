import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
