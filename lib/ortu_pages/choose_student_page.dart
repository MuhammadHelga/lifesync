import 'package:flutter/material.dart';
import '../theme/AppColors.dart';
import 'class_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navbar.dart';

class ChooseStudentPage extends StatefulWidget {
  final String role;
  final String classId;

  const ChooseStudentPage({
    super.key,
    required this.role,
    required this.classId,
  });

  @override
  State<ChooseStudentPage> createState() => _ChooseStudentPageState();
}

class _ChooseStudentPageState extends State<ChooseStudentPage> {
  List<String> childrenNames = [];
  List<Map<String, String>> childrenData = [];

  @override
  void initState() {
    super.initState();
    print('Class ID: ${widget.classId}');
    _fetchChildren();
  }

  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name.trim()[0].toUpperCase();
  }

  Future<String> _getClassNameById(String classId) async {
    final doc =
        await FirebaseFirestore.instance.collection('kelas').doc(classId).get();
    if (doc.exists && doc.data()!.containsKey('nama')) {
      return doc['nama'];
    } else {
      return 'Tanpa Nama Kelas';
    }
  }

  Future<void> _fetchChildren() async {
    try {
      print("Mengambil data anak dari Firestore...");
      final snapshot =
          await FirebaseFirestore.instance
              .collection('kelas')
              .doc(widget.classId)
              .collection('anak')
              .get();

      if (snapshot.docs.isEmpty) {
        print("Tidak ada data anak di kelas ini.");
      }

      // Mengisi childrenData dengan nama dan ID dokumen
      childrenData =
          snapshot.docs.map((doc) {
            final data = doc.data();
            print("Dokumen anak: ${doc.id} => $data");
            return {
              'id': doc.id,
              'name':
                  data.containsKey('name')
                      ? data['name'] as String
                      : 'Tanpa Nama',
            };
          }).toList();

      setState(() {
        childrenNames =
            childrenData
                .map((child) => child['name']!)
                .toList(); // Ambil hanya nama
      });
    } catch (e) {
      print('Gagal mengambil data anak: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data anak')));
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
          'Daftar Anak',
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
                    (context) => ClassOptions(
                      role: widget.role,
                      classId: widget.classId,
                    ),
              ),
            );
          },
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Nama Anak Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Pastikan Anda memilih nama anak Anda dengan benar',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  childrenNames.isEmpty
                      ? Center(child: Text('Tidak ada data anak ditemukan.'))
                      : ListView.separated(
                        itemCount: childrenNames.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final name = childrenNames[index];
                          final initial = getInitial(name);
                          final childId = childrenData[index]['id']!;
                          return GestureDetector(
                            onTap: () async {
                              final className = await _getClassNameById(
                                widget.classId,
                              );

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('selectedChildName', name);
                              await prefs.setString(
                                'selectedChildClass',
                                widget.classId,
                              );
                              await prefs.setString(
                                'selectedChildClassName',
                                className,
                              ); // ← nama ruangan kelas
                              await prefs.setString('selectedChildId', childId);

                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: Color(0xffF7FAFC),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      title: Text('Anak dipilih'),
                                      content: Text(
                                        'Anda memilih $name dari kelas $className',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.success500,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Iya',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xffF7FAFC),
                                              ),
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => BottomNavbar(
                                                        role: widget.role,
                                                        classId: widget.classId,
                                                      ),
                                                ),
                                              ),
                                        ),
                                        TextButton(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.error500,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Tidak',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xffF7FAFC),
                                              ),
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                              );
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary10,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.secondary50,
                                        radius: 28,
                                        child: Text(
                                          initial,
                                          style: const TextStyle(
                                            color: AppColors.primary300,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
