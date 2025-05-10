import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_presence_pages/guru_add_presence_page.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_report_main_page.dart';
import '../ortu_pages/home_pages/home_page.dart';
import '../guru_pages/guru_home_pages/guru_home_page.dart';
import '../ortu_pages/presence_pages/presence_page.dart';
import '../ortu_pages/reporting_pages/reporting_page.dart';
import '../ortu_pages/profile_pages/profile_page.dart';
import '../guru_pages/guru_profile_pages/guru_profile_page.dart';

class BottomNavbar extends StatefulWidget {
  final String role;
  const BottomNavbar({super.key, required this.role});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ortu_pages = [
      HomePage(),
      PresencePage(role: widget.role),
      ReportingPage(role: widget.role),
      ProfilePage(role: widget.role),
    ];
    List<Widget> guru_pages = [
      GuruHomePage(),
      GuruPresencePage(role: widget.role, classId: ' '),
      GuruReportMainPage(role: widget.role),
      GuruProfilePage(role: widget.role),
    ];

    final pages = widget.role == 'Guru' ? guru_pages : ortu_pages;
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff1D99D3),
          type: BottomNavigationBarType.fixed,
          iconSize: 35,
          selectedItemColor: Color(0xffF8FAFC),
          currentIndex: _selectedIndex,
          onTap: _onTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.list : Icons.list),
              label: 'Presensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.book : Icons.book),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.person : Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
