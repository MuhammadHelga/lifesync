import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../ortu_pages/class_options.dart';
import '../pages/login_page.dart';
import '../widgets/bottom_navbar.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  final String classId;
  const RegisterPage({super.key, required this.role,
    required this.classId,});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _hidepass = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                                        (context) =>
                                            LoginPage(role: widget.role, classId: widget.classId,),
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Memantau perkembangan anak dengan lebih mudah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ..._buildSignupForm(),
                          const Spacer(),
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

  List<Widget> _buildSignupForm() {
    return [
      Text(
        'Register',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 10),
      Text('Nama', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.card_membership,
              color: Color(0xff1D99D3),
              size: 30,
            ),
          ),
          hintText: 'Masukkan Nama',
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
      SizedBox(height: 10),
      Text(
        'Email',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.email, color: Color(0xff1D99D3), size: 30),
          ),
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
      SizedBox(height: 10),
      Text(
        'Password',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      TextField(
        controller: _passwordController,
        obscureText: _hidepass,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.lock, color: Color(0xff1D99D3), size: 30),
          ),
          hintText: 'Masukkan Password',
          hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
          filled: true,
          fillColor: Color(0xffF8FAFC),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hidepass = !_hidepass;
              });
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                _hidepass ? Icons.visibility_off : Icons.visibility,
                color: Color(0xff1D99D3),
                size: 30,
              ),
            ),
          ),
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
      SizedBox(height: 40),
      SizedBox(
        height: 55,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final name = _nameController.text.trim();
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();

            if (name.isEmpty || email.isEmpty || password.isEmpty) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Semua field harus diisi')),
              );
              return;
            }

            try {
              final user = await AuthService().registerWithEmail(
                email,
                password,
              );

              if (user != null) {
                await AuthService().saveUserData(user.uid, name, widget.role);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Berhasil registrasi. Silahkan Verifikasi Email Anda',
                    ),
                  ),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(role: widget.role, classId: widget.classId,),
                  ),
                );
              }
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceAll('Exception: ', '')),
                ),
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
            'Register',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(role: widget.role, classId: widget.classId,),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sudah Punya Akun?',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                ' Masuk disini',
                style: TextStyle(
                  color: Color(0xff1D99D3),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
