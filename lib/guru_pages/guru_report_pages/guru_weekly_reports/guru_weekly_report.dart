import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_create_activity_pages/guru_create_activity.dart';
import 'package:lifesync_capstone_project/guru_pages/guru_report_pages/guru_weekly_reports/guru_list_weekly.dart';
import 'package:lifesync_capstone_project/theme/AppColors.dart';

class GuruWeeklyReportPage extends StatefulWidget {
  final String classId;
  const GuruWeeklyReportPage({super.key, required this.classId});

  @override
  State<GuruWeeklyReportPage> createState() => _GuruWeeklyReportPageState();
}

class _GuruWeeklyReportPageState extends State<GuruWeeklyReportPage> {
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> temaList = [];

  Future<void> _fetchTemas() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('tema')
              .get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> fetchedTemas = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();
          fetchedTemas.add({
            'id': doc.id,
            'tema': data['Tema'] ?? 'Tema tanpa judul',
            'minggu': data['minggu'] ?? [],
          });
        }

        fetchedTemas.sort(
          (a, b) => (a['tema'] ?? '').toString().toLowerCase().compareTo(
            (b['tema'] ?? '').toString().toLowerCase(),
          ),
        );

        setState(() {
          temaList = fetchedTemas;
        });
      }
    } catch (e) {
      print('Gagal mengambil daftar tema: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTemas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary5,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Laporan Mingguan',
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView.separated(
          itemCount: temaList.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final isEven = index % 2 == 0;
            final bgColor =
                isEven ? AppColors.primary10 : AppColors.secondary50;
            final tema = temaList[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GuruListWeekly(
                          temaId: tema['id'], // Kirim ID tema
                          classId: widget.classId,
                        ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tema: ${tema['tema'] ?? 'Tema tanpa judul'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Icon(Icons.chevron_right, size: 38),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 28,
                        color: AppColors.primary50,
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("Hapus Tema"),
                                content: Text(
                                  "Yakin ingin menghapus tema '${tema['tema']}'?",
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Batal"),
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                  ),
                                  TextButton(
                                    child: const Text("Hapus"),
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          await FirebaseFirestore.instance
                              .collection('kelas')
                              .doc(widget.classId)
                              .collection('tema')
                              .doc(tema['id'])
                              .delete();

                          setState(() {
                            temaList.removeAt(index); // langsung update list
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => GuruCreateActivityPage(
                    classId: widget.classId,
                    initialLaporan: 'Mingguan',
                    isLocked: true,
                  ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF1D99D3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
