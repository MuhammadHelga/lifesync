import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './guru_detail_page.dart';
import 'package:lifesync_capstone_project/theme/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuruHomePage extends StatefulWidget {
  @override
  State<GuruHomePage> createState() => _GuruHomePageState();
}

class _GuruHomePageState extends State<GuruHomePage> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadUserName();
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

  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  final List<Map<String, String>> outingClasses = [
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: AppColors.primary50, // Ganti warna sesuai kebutuhan
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 38),
            onPressed: () {
              // Tindakan ketika notifikasi diklik
              print("Notifikasi diklik");
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ), // Menambahkan radius di bagian bawah
        clipBehavior: Clip.hardEdge,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hai,',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _name != null ? 'Miss $_name' : 'Loading...',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Slider
                    _buildOutingClassSlider(),

                    // School Updates
                    Text(
                      'Update Kegiatan Sekolah',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),

                    UpdateCard(
                      title: 'Kado Cinta Ramadhan',
                      description:
                          'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                      imageUrl: 'assets/images/placeholder_updates.jpg',
                    ),
                    UpdateCard(
                      title: 'Cooking Class',
                      description:
                          'Lorem ipsum dolor sit amet consectetur. Dolor interdum odio quam sed aliquam.',
                      imageUrl: 'assets/images/placeholder_updates.jpg',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutingClassSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items:
              outingClasses.map((outingClass) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          outingClass['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 212,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 16,
                        right: 16,
                        child: Text(
                          outingClass['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              outingClasses.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = entry.key;
                    });
                  },
                  child: Container(
                    width: 10.0,
                    height: 30.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class UpdateCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  UpdateCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFC5E7F7),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => GuruDetailPage(
                    title: title,
                    description: description,
                    imageUrl: imageUrl,
                  ),
            ),
          );
        },
        child: ListTile(
          leading: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
        ),
      ),
    );
  }
}

class OutingClassSlider extends StatefulWidget {
  @override
  State<OutingClassSlider> createState() => _OutingClassSliderState();
}

class _OutingClassSliderState extends State<OutingClassSlider> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  final List<Map<String, String>> outingClasses = [
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
    {
      'image': 'assets/images/placeholder_slider.jpg',
      'title': 'Outing Class "Balai Pengkajian Teknologi Pertanian (BPTP)"',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          items:
              outingClasses.map((outingClass) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Radius pada card
                  ),
                  elevation: 4, // Menambahkan bayangan pada card
                  child: Column(
                    children: [
                      // Stack untuk menempatkan gambar di bawah dan teks di atas
                      Stack(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                              bottom: Radius.circular(16),
                            ), // Radius pada gambar
                            child: Container(
                              height:
                                  212, // Menyesuaikan tinggi card dengan gambar
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(color: Colors.black),
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 20.0,
                                    spreadRadius: -7.0,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                outingClass['image']!,
                                fit: BoxFit.cover,
                                height: 212,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8, // Jarak teks dari bawah
                            left: 16,
                            right: 16,
                            child: Text(
                              outingClass['title']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index; // Update index saat halaman berubah
              });
            },
          ),
        ),
        // Indikator titik untuk carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              outingClasses.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    // Menggunakan setState untuk perubahan halaman
                    setState(() {
                      _currentIndex = entry.key;
                    });
                  },
                  child: Container(
                    width: 10.0,
                    height: 30.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentIndex == entry.key
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
