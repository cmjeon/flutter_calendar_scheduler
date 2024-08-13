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

  // 조회
  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date);
    // 일정 업데이트
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    // 리슨하는 위젯들 업데이트
    notifyListeners();
  }

  // 생성
  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    final savedSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(
      targetDate,
      (value) => [
        ...value,
        schedule.copyWith(
          id: savedSchedule,
        ),
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [schedule],
    );
    notifyListeners();
  }

  // 삭제
  void deleteSchedules({
    required DateTime date,
    required String id,
  }) async {
    final resp = await repository.deleteSchedule(id: id);

    cache.update(date, (value) => value.where((e) => e.id != id).toList(),
        ifAbsent: () => []);
    notifyListeners();
  }

  // 수정
  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }
}
