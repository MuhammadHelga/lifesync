import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../pages/login_page.dart';
import 'edit_profile.dart';
import '../../theme/AppColors.dart';

import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String role;
  final String classId;
  const ProfilePage({super.key, required this.role, required this.classId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  String? _childName;
  String? _childClass;
  String childName = '';
  String ruangKelas = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadChildAndClassInfo();
  }

  // Ambil nama pengguna dari Firestore
  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          _name = doc['name'];
        });
      }
    }
  }

  Future<void> _loadChildAndClassInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedChildId = prefs.getString('selectedChildId');

    if (selectedChildId != null && widget.classId.isNotEmpty) {
      // Ambil data anak
      final anakSnapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .doc(selectedChildId)
              .get();

      // Ambil data kelas
      final kelasSnapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .get();

      if (anakSnapshot.exists && kelasSnapshot.exists) {
        final anakData = anakSnapshot.data();
        final kelasData = kelasSnapshot.data();

        setState(() {
          childName = anakData?['name'] ?? 'Nama tidak ditemukan';
          ruangKelas = kelasData?['ruangan'] ?? 'Ruangan tidak ditemukan';
        });
      } else {
        print('Dokumen anak atau kelas tidak ditemukan.');
      }
    } else {
      print('selectedChildId atau classId kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Profil',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary5,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12.0),
          icon: Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
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
                    (context) => BottomNavbar(
                      role: widget.role,
                      classId: widget.classId,
                    ),
              ),
            );
          },
        ),
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff1D99D3),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/photo1.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _name ?? 'Loading...',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffF2F9FD),
                                  ),
                                ),
                                Text(
                                  'Orang Tua',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffF2F9FD),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.edit_square,
                                color: Color(0xffF2F9FD),
                                size: 30,
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditProfile(
                                          role: widget.role,
                                          classId: widget.classId,
                                        ),
                                  ),
                                );
                                await _loadUserName();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Color(0xffFDF2CE),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/photo2.png',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anak',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$childName',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  '$ruangKelas',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PENGATURAN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 242, 245),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                color: Color(0xff333333),
                                size: 30,
                              ),
                              Text('Umum', style: TextStyle(fontSize: 20)),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            color: Color(0xffAFB1B6),
                            width: double.infinity,
                            height: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outlined,
                                color: Color(0xff333333),
                                size: 30,
                              ),
                              Text('Tentang', style: TextStyle(fontSize: 20)),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            color: Color(0xffAFB1B6),
                            width: double.infinity,
                            height: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: InkWell(
                          onTap: () async {
                            await AuthService().logout();

                            if (!context.mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LoginPage(
                                      role: widget.role,
                                      classId: widget.classId,
                                    ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Color(0xffDC040F),
                                size: 30,
                              ),
                              Text(
                                'LogOut',
                                style: TextStyle(
                                  color: Color(0xffDC040F),
                                  fontSize: 20,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.chevron_right,
                                color: Color(0xffA8A8A8),
                                size: 30,
                              ),
                            ],
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
    );
  }
}
