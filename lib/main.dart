import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/database/drift_database.dart';
import 'package:flutter_calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter_calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter_calendar_scheduler/screen/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  // 플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final repository = ScheduleRepository();
  final scheudleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => scheudleProvider,
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
