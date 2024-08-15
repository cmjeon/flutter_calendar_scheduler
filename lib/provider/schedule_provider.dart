import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/model/schedule_model.dart';
import 'package:flutter_calendar_scheduler/repository/auth_repository.dart';
import 'package:flutter_calendar_scheduler/repository/schedule_repository.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ScheduleRepository scheduleRepository;

  String? accessToken;
  String? refreshToken;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider(
      {required this.authRepository, required this.scheduleRepository})
      : super() {
    getSchedules(date: selectedDate);
  }

  // 조회
  void getSchedules({required DateTime date}) async {
    final resp = await scheduleRepository.getSchedules(date: date);
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
      final savedSchedule =
          await scheduleRepository.createSchedule(schedule: schedule);
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
      await scheduleRepository.deleteSchedule(id: id);
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

  // 업데이트 토큰
  updateToken({
    String? refreshToken,
    String? accessToken,
  }) {
    if (accessToken != null) {
      this.accessToken = accessToken;
    }
    notifyListeners();
  }

  // 회원가입
  Future<void> register({
    required String email,
    required String password,
  }) async {
    // AuthRepository 에 미리 구현해둔 register() 함수를 실행
    final resp = await authRepository.register(
      email: email,
      password: password,
    );

    // 반환받은 토큰을 기반으로 토큰 프로퍼티를 업데이트합니다.
    updateToken(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  // 로그인
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // AuthRepository 에 미리 구현해둔 login() 함수를 실행
    final resp = await authRepository.login(
      email: email,
      password: password,
    );

    // 반환받은 토큰을 기반으로 토큰 프로퍼티를 업데이트합니다.
    updateToken(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  // 로그아웃
  logout() {
    refreshToken = null;
    accessToken = null;

    cache = {};
    notifyListeners();
  }

  // 토큰 재발급
  rotateToken({
    required String refreshToken,
    required bool isRefreshToken,
  }) async {
    if(isRefreshToken) {
      final token = await authRepository.rotateRefreshToken(
        refreshToken: refreshToken,
      );

      this.refreshToken = token;
    } else {
      final token = await authRepository.rotateAccessToken(
        refreshToken: refreshToken,
      );
      accessToken = token;
    }

    notifyListeners();
  }
}
