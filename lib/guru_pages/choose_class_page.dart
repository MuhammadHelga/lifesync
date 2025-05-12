import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import 'create_class_page.dart';
import '../widgets/bottom_navbar.dart';
import '../pages/login_page.dart';
import 'join_class_page.dart';

class ChooseClassPage extends StatefulWidget {
  final String role;
  final String classId;
  const ChooseClassPage({Key? key, required this.role, required this.classId})
    : super(key: key);

  @override
  State<ChooseClassPage> createState() => _ChooseClassPageState();
}

class _ChooseClassPageState extends State<ChooseClassPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color.fromARGB(255, 176, 230, 255), Color(0xFFFFFFFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Container(
              padding: EdgeInsets.all(6.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neutral100,
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.primary50,
                size: 26,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          LoginPage(role: widget.role, classId: widget.classId),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 100,
              ), // Menambahkan padding agar konten naik
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    MainAxisAlignment.start, // Mengubah alignment jadi start
                children: <Widget>[
                  // Logo
                  Image.asset(
                    'assets/images/logo_paud.png',
                    width: 250,
                    height: 250,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tambahkan kelas untuk memulai',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => JoinClassPage(
                                        role: widget.role,
                                        classId: widget.classId,
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              'Bergabung\nke Kelas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF1779A6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF54B7EB),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CreateClassPage(role: widget.role),
                                ),
                              );
                            },
                            child: const Text(
                              'Buat\nKelas Baru',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
