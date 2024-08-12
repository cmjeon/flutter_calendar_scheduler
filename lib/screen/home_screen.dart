import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/component/main_calendar.dart';
import 'package:flutter_calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:flutter_calendar_scheduler/component/schedule_card.dart';
import 'package:flutter_calendar_scheduler/component/today_banner.dart';
import 'package:flutter_calendar_scheduler/const/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate,),
                // BottomSheet 의 높이를 화면의 최대 높이로 경의하고 스크롤 가능하게 변경
                isScrollControlled: true);
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
            child: Column(children: [
          MainCalendar(
            selectedDate: selectedDate,
            onDaySelected: onDaySelected,
          ),
          SizedBox(height: 8.0),
          TodayBanner(selectedDate: selectedDate, count: 0),
          SizedBox(height: 8.0),
          ScheduleCard(startTime: 12, endTime: 14, content: '프로그래밍 공부')
        ])));
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
