import 'package:flutter/material.dart';
import '../pages/login_page.dart';

import '../services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  final String role;
  final String classId;
  const ForgotPassword({super.key, required this.role, required this.classId});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics:
                    constraints.maxHeight < 600
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: Color(0xff1D99D3),
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => LoginPage(
                                          role: widget.role,
                                          classId: widget.classId,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Image.asset(
                              'assets/images/logo_paud.png',
                              height: 150,
                              width: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'Memantau perkembangan anak dengan lebih mudah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ..._buildResetPass(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResetPass() {
    return [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            'Lupa Password?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Text(
        'Masukkan Email yang terdaftar dalam akun. Petunjuk perubahan password akan dikirim melalui email.',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          'Email',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Masukkan Email',
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
          filled: true,
          fillColor: Color(0xffF8FAFC),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Color(0xff1D99D3), width: 3),
          ),
        ),
      ),
      SizedBox(height: 20),
      SizedBox(
        height: 55,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final email = emailController.text.trim();
            if (email.isEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Masukkan email anda')));
              return;
            }

            try {
              await AuthService().sendPasswordResetEmail(email);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Link reset password telah dikirim ke email anda',
                  ),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          LoginPage(role: widget.role, classId: widget.classId),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gagal mengirim reset password')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff1D99D3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            'Kirim',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      SizedBox(height: 20),
    ];
  }
}
