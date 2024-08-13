import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/component/custom_text_field.dart';
import 'package:flutter_calendar_scheduler/const/colors.dart';
import 'package:flutter_calendar_scheduler/model/schedule_model.dart';
import 'package:flutter_calendar_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({required this.selectedDate, Key? key})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
        key: formKey,
        child: Container(
            height: MediaQuery.of(context).size.height / 2 + bottomInset,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 8, right: 8, top: 8, bottom: bottomInset),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: CustomTextField(
                    label: '시작 시간',
                    isTime: true,
                    onSaved: (String? val) {
                      startTime = int.parse(val!);
                    },
                    validator: timeValidator,
                  )),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: CustomTextField(
                    label: '종료 시간',
                    isTime: true,
                    onSaved: (String? val) {
                      endTime = int.parse(val!);
                    },
                    validator: timeValidator,
                  )),
                ]),
                SizedBox(height: 8.0),
                Expanded(
                    child: CustomTextField(
                  label: '내용',
                  isTime: false,
                  onSaved: (String? val) {
                    content = val;
                  },
                  validator: contentValidator,
                )),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSavePressed(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        foregroundColor: Colors.white),
                    child: Text('저장'),
                  ),
                )
              ]),
            )));
  }

  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // print('startTime: $startTime, endTime: $endTime, content: $content');
      context.read<ScheduleProvider>().createSchedule(
            schedule: ScheduleModel(
              id: ('new_model'),
              content: content!,
              date: widget.selectedDate,
              startTime: startTime!,
              endTime: endTime!,
            ),
          );

      Navigator.of(context).pop(); // 뒤로가기 기능으로 일정생성 화면 닫아주기
    }
  }

  // 시간검증
  String? timeValidator(String? val) {
    if (val == null) {
      return '시간을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자만 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0 ~ 24 사이의 숫자를 입력해주세요';
    }

    return null;
  }

  // 내용 검증
  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '내용을 입력해주세요';
    }
    return null;
  }
}
