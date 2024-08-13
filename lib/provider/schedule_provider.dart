import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/model/schedule_model.dart';
import 'package:flutter_calendar_scheduler/repository/schedule_repository.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.repository}) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date);
    // 일정 업데이트
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    // 리슨하는 위젯들 업데이트
    notifyListeners();
  }
}
