import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/guru_add_daily.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/guru_add_semester.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/guru_add_weekly.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';
import 'guru_add_announcement.dart';

class GuruCreateActivityPage extends StatefulWidget {
  final String? initialLaporan;
  final bool isLocked;
  final String classId;

  const GuruCreateActivityPage({
    super.key,
    this.initialLaporan,
    this.isLocked = false,
    required this.classId,
  });

  @override
  State<GuruCreateActivityPage> createState() => _GuruCreateActivityPageState();
}

class _GuruCreateActivityPageState extends State<GuruCreateActivityPage> {
  late String _selectedLaporan;
  final List<String> _laporanOptions = [
    'Harian',
    'Mingguan',
    'Semester',
    'Pengumuman',
  ];

  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLaporan = widget.initialLaporan ?? 'Harian';
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // Menampilkan halaman yang sesuai berdasarkan dropdown
  Widget _getLaporanPage() {
    switch (_selectedLaporan) {
      case 'Harian':
        return AddDailyPage(classId: widget.classId);
      case 'Mingguan':
        return const AddWeeklyPage();
      case 'Semester':
        return const AddSemesterPage();
      case 'Pengumuman':
        return const AddAnnouncementPage();
      default:
        return const SizedBox(); // Default page empty or placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Buat Laporan',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.primary5,
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 12.0),
          icon: Container(
            padding: const EdgeInsets.all(3.0),
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
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 34, 30, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            widget.isLocked
                ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary30, width: 3),
                    borderRadius: BorderRadius.circular(9999),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _selectedLaporan,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                )
                : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary30, width: 3),
                    borderRadius: BorderRadius.circular(9999),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLaporan,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLaporan = newValue;
                          });
                        }
                      },
                      items:
                          _laporanOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
            const SizedBox(height: 24),
            _getLaporanPage(),
          ],
        ),
      ),
    );
  }
}
