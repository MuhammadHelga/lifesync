import 'package:flutter/material.dart';
import '../reporting_page.dart';
import '../../../theme/AppColors.dart';
import '../daily_report/detail_daily_report.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaysReportingPage extends StatefulWidget {
  final String classId;
  const DaysReportingPage({super.key, required this.classId});

  @override
  State<DaysReportingPage> createState() => _DaysReportingPageState();
}

class _DaysReportingPageState extends State<DaysReportingPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadLaporanHarian();
    });
  }

  Future<void> _loadLaporanHarian() async {
    final String dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('laporan_harian')
              .doc(dateKey)
              .collection('kelas')
              .doc(widget.classId)
              .collection('laporan')
              .orderBy('createdAt', descending: true)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> loadedActivities = [];

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          loadedActivities.add({
            'id': doc.id,
            'title': data['title'] ?? '',
            'description': data['deskripsi'] ?? '',
            'date': DateFormat(
              'EEEE, d MMMM yyyy',
              'id_ID',
            ).format((data['tanggal'] as Timestamp).toDate()),
            'image':
                data['imageUrls'] != null && data['imageUrls'].isNotEmpty
                    ? data['imageUrls'][0]
                    : 'assets/images/laporan_img.png',
            'dateKey': dateKey,
          });
        }

        setState(() {
          activities = loadedActivities;
        });
      } else {
        setState(() {
          activities = [];
        });
        print('❌ Tidak ada laporan untuk tanggal ini');
      }
    } catch (e) {
      print('❌ Gagal memuat data: $e');
      setState(() {
        activities = [];
      });
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff1D99D3),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadLaporanHarian();
    }
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F9FD),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Harian',
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
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              const Text(
                'Pilih Tanggal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var item in [
                    selectedDate.day.toString(),
                    _monthName(selectedDate.month),
                    selectedDate.year.toString(),
                  ])
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xffC5E7F7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              const Text(
                'Semua Aktivitas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child:
                    activities.isEmpty
                        ? Center(
                          child: Text(
                            'Belum ada aktivitas.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            return ActivityCard(
                              title: activity['title']!,
                              date: activity['date']!,
                              description: activity['description'] ?? '',
                              imagePath: activity['image']!,
                              onDelete: () async {
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.primary10,
                                      title: const Text('Konfirmasi Hapus'),
                                      content: const Text(
                                        'Apakah Anda yakin ingin menghapus laporan ini?',
                                      ),
                                      actions: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.error300,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: const Text(
                                              'Batal',
                                              style: TextStyle(
                                                color: AppColors.neutral100,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.success300,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: const Text(
                                              'Hapus',
                                              style: TextStyle(
                                                color: AppColors.neutral100,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String imagePath;
  final String description;
  final VoidCallback onDelete;

  const ActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget =
        imagePath.startsWith('http')
            ? Image.network(
              imagePath,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 80);
              },
            )
            : Image.asset(
              imagePath,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
            );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailDailyReport(
                  title: title,
                  date: date,
                  imagePath: imagePath,
                  description: description,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xffC5E7F7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(date, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
