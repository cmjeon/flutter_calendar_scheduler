import 'package:flutter/material.dart';

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
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(),
                const SizedBox(height: 8.0),
                TextFormField(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('회원가입'),
                ),
                ElevatedButton(
                  onPressed: () async {},
                  child: Text('로그인'),
                ),
              ])),
    );
  }
}
