import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/model/schedule_model.dart';
import 'package:flutter_calendar_scheduler/repository/schedule_repository.dart';
import 'package:uuid/uuid.dart';

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
    final uuid = Uuid();
    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tempId);
    // 긍정적 응답 캐시 업데이트
    cache.update(
      targetDate,
      (value) => [
        ...value,
        newSchedule,
      ]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        ),
      ifAbsent: () => [newSchedule],
    );
    notifyListeners();

    try {
      final savedSchedule = await repository.createSchedule(schedule: schedule);
      // 응답기반 캐시 업데이트
      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId
                ? e.copyWith(
                    id: savedSchedule,
                  )
                : e)
            .toList(),
      );
    } catch (e) {
      // 실패 시 캐시 롤백
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }
    notifyListeners();
  }

  // 삭제
  void deleteSchedules({
    required DateTime date,
    required String id,
  }) async {
    final targetSchedule =
        cache[date]!.firstWhere((e) => e.id == id); // 삭제할 일정 기억

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners(); // 캐시 업데이트 반영

    try {
      await repository.deleteSchedule(id: id);
    } catch (e) {
      // 실패 시 캐시 롤백
      cache.update(
        date,
        (value) => [...value, targetSchedule]..sort(
            (a, b) => a.startTime.compareTo(
              b.startTime,
            ),
          ),
      );
    }
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
