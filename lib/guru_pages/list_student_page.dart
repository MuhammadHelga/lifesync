import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifesync_capstone_project/guru_pages/input_student_page.dart';
import '../theme/AppColors.dart';
import '../widgets/bottom_navbar.dart';

class ListStudentPage extends StatefulWidget {
  final String role;
  final String classId;

  const ListStudentPage({super.key, required this.role, required this.classId});

  @override
  _ListStudentPageState createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name.trim()[0].toUpperCase();
  }

  void _deleteStudent(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Anak'),
            content: Text('Apakah Anda yakin ingin menghapus "$name"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Hapus'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('anak').doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anak "$name" berhasil dihapus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('📌 DEBUG className yang dikirim: ${widget.classId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Daftar Anak',
          style: TextStyle(
            fontSize: 20,
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
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 50,
          left: 30,
          right: 30,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('kelas')
                        .doc(widget.classId)
                        .collection('anak')
                        .orderBy('createdAt', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Belum ada anak di kelas ini."),
                    );
                  }

                  final students = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final name = student['name'] ?? 'Tanpa Nama';
                      final initial = getInitial(name);
                      final docId = student.id;

                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.primary300,
                              ),
                              onPressed: () => _deleteStudent(docId, name),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BottomNavbar(role: widget.role, classId: widget.classId,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary5,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: AppColors.primary50, width: 2),
                  ),
                ),
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => InputStudentPage(
                      role: widget.role,
                      classId: widget.classId,
                    ),
              ),
            );
          },
          backgroundColor: AppColors.primary50,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28, color: AppColors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
