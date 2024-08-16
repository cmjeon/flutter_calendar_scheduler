import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/component/login_text_field.dart';
import 'package:flutter_calendar_scheduler/const/colors.dart';
import 'package:flutter_calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter_calendar_scheduler/screen/home_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Form 을 제어할 때 사용되는 GlobalKey
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/img/logo.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                const SizedBox(height: 16.0),
                LoginTextField(
                    onSaved: (String? val) {
                      email = val!;
                    },
                    validator: (String? val) {
                      // 이메일이 입력되지 않았으면 에러 메시지를 반환합니다.
                      if (val?.isEmpty ?? true) {
                        return '이메일을 입력해주세요.';
                      }
                      // 정규표현식을 이용해 이메일 형식이 맞는지 검사합니다.
                      RegExp req = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!req.hasMatch(val!)) {
                        return '이메일 형식이 올바르지 않습니다.';
                      }
                      return null;
                    },
                    hintText: '이메일'),
                const SizedBox(height: 8.0),
                LoginTextField(
                    obscureText: true,
                    onSaved: (String? val) {
                      password = val!;
                    },
                    validator: (String? val) {
                      // 비밀번호가 입력되지 않았으면 에러 메시지를 반환합니다.
                      if (val?.isEmpty ?? true) {
                        return '비밀번호를 입력해주세요.';
                      }
                      // 입력된 비밀번호가 4자리에서 8자리 사이인지 확인합니다.
                      if (val!.length < 4 || val.length > 8) {
                        return '비밀번호는 4 ~ 8자 사이로 입력해 주세요.';
                      }
                      return null;
                    },
                    hintText: '비밀번호'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    onRegisterPress(provider);
                  },
                  child: Text('회원가입'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: SECONDARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    onLoginPress(provider);
                  },
                  child: Text('로그인'),
                ),
              ]),
        ),
      ),
    );
  }

  bool saveAndValidateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    formKey.currentState!.save();
    return true;
  }

  // 회원가입
  onRegisterPress(ScheduleProvider provider) async {
    // form 검증
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      await provider.register(email: email, password: password);
    } on DioException catch (e) {
      if (e.response != null) {
        message = e.response!.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      } else {
        message = '알 수 없는 오류가 발생했습니다.';
      }
    } finally {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    }
  }

  // 로그인
  onLoginPress(ScheduleProvider provider) async {
    // form 검증
    if (!saveAndValidateForm()) {
      return;
    }

    String? message;

    try {
      await provider.login(email: email, password: password);
    } on DioException catch (e) {
      if (e.response != null) {
        message = e.response!.data['message'] ?? '알 수 없는 오류가 발생했습니다.';
      } else {
        message = '알 수 없는 오류가 발생했습니다.';
      }
    } finally {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    }
  }
}
