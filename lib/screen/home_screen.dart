import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/component/main_calendar.dart';
import 'package:flutter_calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:flutter_calendar_scheduler/component/schedule_card.dart';
import 'package:flutter_calendar_scheduler/component/today_banner.dart';
import 'package:flutter_calendar_scheduler/const/colors.dart';
import 'package:flutter_calendar_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    final selectedDate = provider.selectedDate;

    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (_) => ScheduleBottomSheet(
                      selectedDate: selectedDate,
                    ),
                // BottomSheet 의 높이를 화면의 최대 높이로 경의하고 스크롤 가능하게 변경
                isScrollControlled: true);
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
            child: Column(children: [
          MainCalendar(
            selectedDate: selectedDate,
            onDaySelected: (selectedDate, focusedDate) =>
                onDaySelected(selectedDate, focusedDate, context),
          ),
          SizedBox(height: 8.0),
          TodayBanner(selectedDate: selectedDate, count: schedules.length),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];

                return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    provider.deleteSchedules(
                        date: selectedDate, id: schedule.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                    child: ScheduleCard(
                      startTime: schedule.startTime,
                      endTime: schedule.endTime,
                      content: schedule.content,
                    ),
                  ),
                );
              },
            ),
          ),
        ])));
  }

  void onDaySelected(
      DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
