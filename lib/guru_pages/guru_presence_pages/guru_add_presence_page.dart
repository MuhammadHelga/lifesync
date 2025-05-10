import 'package:flutter/material.dart';
import '../../theme/AppColors.dart';
import '../../widgets/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruPresencePage extends StatefulWidget {
  final String role;
  final String classId;
  const GuruPresencePage({
    super.key,
    required this.role,
    required this.classId,
  });

  @override
  State<GuruPresencePage> createState() => _GuruPresencePageState();
}

class _GuruPresencePageState extends State<GuruPresencePage> {
  DateTime selectedDate = DateTime.now();
  List<String> childrenNames = [];
  List<String> presenceStatus = [];

  Map<String, int> statusCounts = {
    'Hadir': 0,
    'Sakit': 0,
    'Izin': 0,
    'Alpha': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchChildrenData();
  }

  void _fetchChildrenData() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('anak')
            .where('classId', isEqualTo: widget.classId)
            .get();
    setState(() {
      childrenNames =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      presenceStatus = List.filled(childrenNames.length, 'Hadir');
      _updateStatusCounts();
    });
  }

  void _updateStatusCounts() {
    statusCounts = {'Hadir': 0, 'Sakit': 0, 'Izin': 0, 'Alpha': 0};

    for (var status in presenceStatus) {
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }
  }

  String getInitial(String presence) =>
      presence.isNotEmpty ? presence[0].toUpperCase() : '';

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
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50,
        elevation: 0,
        title: Text(
          'Presensi',
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
                builder: (context) => BottomNavbar(role: widget.role),
              ),
            );
          },
        ),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
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
                  Text(
                    'Total Kehadiran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Table(
                        border: TableBorder.all(
                          width: 0,
                          color: Colors.transparent,
                        ),
                        children: [
                          TableRow(
                            children: [
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffA8EE87),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Hadir',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8D96D),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'Izin',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xffA8EE87),
                                  ),
                                ),
                                child: Text(
                                  '${statusCounts['Hadir']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xffF8D96D),
                                  ),
                                ),
                                child: Text(
                                  '${statusCounts['Izin']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFA470),
                                ),
                                child: Text(
                                  'Sakit',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffFF6666),
                                ),
                                child: Text(
                                  'Alpha',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xffFFA470),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  '${statusCounts['Sakit']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                width: 170,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xffFF6666),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  '${statusCounts['Alpha']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Nama Anak',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: childrenNames.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final name = childrenNames[index];
                  final presence = presenceStatus[index];
                  final initialPresence = getInitial(presence);

                  Color presenceColor = _getPresenceColor(presence);

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: Color(0xffF7FAFC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: presenceColor,
                                        radius: 30,
                                        child: Text(
                                          initialPresence,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        presence,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Ubah keterangan kehadiran:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _buildPresenceButton(
                                        'Hadir',
                                        Color(0xffA8EE87),
                                        index,
                                      ),
                                      _buildPresenceButton(
                                        'Sakit',
                                        Color(0xffFFA470),
                                        index,
                                      ),
                                      _buildPresenceButton(
                                        'Izin',
                                        Color(0xffF8D96D),
                                        index,
                                      ),
                                      _buildPresenceButton(
                                        'Alpha',
                                        Color(0xffFF6666),
                                        index,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: presenceColor,
                            radius: 28,
                            child: Text(
                              initialPresence,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
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

  Color _getPresenceColor(String presence) {
    switch (presence) {
      case 'Hadir':
        return Color(0xffA8EE87);
      case 'Izin':
        return Color(0xffF8D96D);
      case 'Sakit':
        return Color(0xffFFA470);
      case 'Alpha':
        return Color(0xffFF6666);
      default:
        return AppColors.secondary50;
    }
  }

  Widget _buildPresenceButton(String label, Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          presenceStatus[index] = label;
          _updateStatusCounts(); // Update counts when status changes
        });
        Navigator.of(context).pop();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
