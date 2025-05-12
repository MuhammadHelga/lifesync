import 'package:flutter/material.dart';
import 'dart:async';
import 'role_option_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key,});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleOptionPage(classId: '',)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_paud.png'),
                SizedBox(height: 32),
                Text(
                  'Taman Penitipan Anak, Kelompok Bermain, dan Taman Kanak-Kanak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff2E3094),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
