import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';
import '../../pages/login_page.dart';
import './guru_edit_profile.dart';

import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuruProfilePage extends StatefulWidget {
  final String role;
  final String classId;
  const GuruProfilePage({super.key, required this.role, required this.classId});

  @override
  _GuruProfilePageState createState() => _GuruProfilePageState();
}

class _GuruProfilePageState extends State<GuruProfilePage> {
  String? _name;
  String? kodeKelas;
  String? ruangan;

  final List<Kelas> semuaKelas = [
    Kelas(
      nama: 'Kelas KB–A1',
      kode: 'Kode Kelas',
      tahunAjaran: 'Tahun ajaran 2024/2025 (Ruangan Kelas)',
      aktif: true,
    ),
    Kelas(
      nama: 'Kelas KB–A2',
      kode: 'Kode Kelas',
      tahunAjaran: 'Tahun ajaran 2023/2024 (Ruangan Kelas)',
    ),
    Kelas(
      nama: 'Kelas KB–B1',
      kode: 'Kode Kelas',
      tahunAjaran: 'Tahun ajaran 2022/2023 (Ruangan Kelas)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadClassInfo();
  }

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

  Future<void> _loadClassInfo() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .get();

      if (doc.exists) {
        setState(() {
          kodeKelas = doc['kode_kelas'];
          ruangan = doc['ruangan'];
        });
      }
    } catch (e) {
      print('Gagal mengambil data kelas: $e');
    }
  }

  Widget buildKelasCard(Kelas kelas) {
    Color bgColor = kelas.aktif ? Color(0xffD3EFFD) : Color(0xffFFF3C2);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kelas.nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 2),
                Text(kelas.kode),
                Text(kelas.tahunAjaran),
              ],
            ),
          ),
          if (!kelas.aktif) Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
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
              size: 22,
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
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
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffF2F9FD),
                          ),
                        ),
                        Text(
                          'Guru',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffF2F9FD),
                          ),
                        ),
                        Text(
                          ruangan != null ? '$ruangan' : 'Memuat Kelas...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffF2F9FD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          kodeKelas != null ? '$kodeKelas' : 'Memuat Kode...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffF2F9FD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.edit_square,
                        color: Color(0xffF2F9FD),
                        size: 26,
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GuruEditProfile(
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 20,
                        left: 40,
                      ),
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
                      margin: EdgeInsets.symmetric(horizontal: 30),
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
                          buildSettingItem(Icons.settings_outlined, 'Umum'),
                          buildDivider(),
                          buildSettingItem(Icons.info_outlined, 'Tentang'),
                          buildDivider(),
                          InkWell(
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
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.logout_outlined,
                                    color: Color(0xffDC040F),
                                    size: 30,
                                  ),
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
                        ],
                      ),
                    ),

                    // Kelas Aktif
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 8,
                        left: 40,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Kelas Aktif',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ...semuaKelas
                        .where((kelas) => kelas.aktif)
                        .map((kelas) => buildKelasCard(kelas))
                        .toList(),

                    // Riwayat Kelas
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 8,
                        left: 40,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Riwayat Kelas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ...semuaKelas
                        .where((kelas) => !kelas.aktif)
                        .map((kelas) => buildKelasCard(kelas))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem(IconData icon, String label) {
    return InkWell(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(icon, color: Color(0xff333333), size: 30),
          ),
          Text(label, style: TextStyle(fontSize: 20)),
          Spacer(),
          Icon(Icons.chevron_right, color: Color(0xffA8A8A8), size: 30),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        color: Color(0xffAFB1B6),
        width: double.infinity,
        height: 1,
      ),
    );
  }
}

class Kelas {
  final String nama;
  final String kode;
  final String tahunAjaran;
  final bool aktif;

  Kelas({
    required this.nama,
    required this.kode,
    required this.tahunAjaran,
    this.aktif = false,
  });
}
