import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/input_student_page.dart';
import '/theme/AppColors.dart';

import '../services/auth_service.dart';
import 'package:lifesync_capstone_project/guru_pages/input_student_page.dart';
import '/theme/AppColors.dart';

import '../services/auth_service.dart';

class CreateClassPage extends StatefulWidget {
  final String role;
  const CreateClassPage({super.key, required this.role});

  @override
  _CreateClassPageState createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final TextEditingController _namaKelasController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _tahunAjaranController = TextEditingController();

  Future<void> _simpanKelas() async {
    final String namaKelas = _namaKelasController.text.trim();
    final String ruangan = _ruanganController.text.trim();
    final String tahunAjaran = _tahunAjaranController.text.trim();

    if (namaKelas.isEmpty || ruangan.isEmpty || tahunAjaran.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Harap lengkapi semua field')));
      return;
    }

    try {
      final classId = await AuthService().simpanKelas(
        namaKelas: namaKelas,
        ruangan: ruangan,
        tahunAjaran: tahunAjaran,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  InputStudentPage(role: widget.role, classId: classId),
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

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
          elevation: 0,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: Container(
              padding: const EdgeInsets.all(6.5),
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
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/images/logo_paud.png', height: 150),
                    const SizedBox(height: 20),
                    const Text(
                      'Buat Kelas Baru',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Nama Kelas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _namaKelasController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Kelas',
                  hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xffF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ruangan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ruanganController,
                decoration: InputDecoration(
                  hintText: 'Masukkan ruangan kelas',
                  hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xffF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tahun Ajaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tahunAjaranController,
                decoration: InputDecoration(
                  hintText: 'ex: 2023/2024',
                  hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xffF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xff1D99D3),
                      width: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanKelas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary50,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Buat Kelas',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
