import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_calendar_scheduler/model/schedule_model.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule'; // 안드로이드에서는 10.0.2.2 가 localhost

  // 조회
  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    return resp.data
        .map<ScheduleModel>(
          (x) => ScheduleModel.fromJson(
            json: x,
          ),
        )
        .toList();
  }

  // 등록
  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();
    final resp = await _dio.post(
      _targetUrl,
      data: json,
    );
    return resp.data?['id'];
  }

  // 삭제
  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {'id': id});
    return resp.data?['id'];
  }
}
