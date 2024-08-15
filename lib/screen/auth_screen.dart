import 'package:flutter/material.dart';
import 'package:flutter_calendar_scheduler/component/login_text_field.dart';
import 'package:flutter_calendar_scheduler/const/colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/img/logo.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
            ),
          ),
          const SizedBox(height: 16.0),
          LoginTextField(onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '이메일'),
          const SizedBox(height: 8.0),
          LoginTextField(obscureText: true,
              onSaved: (String? val) {},
              validator: (String? val) {},
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
              onPressed: () {},
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
          onPressed: () async {},
          child: Text('로그인'),
        ),
        ])),
    );
  }
}
