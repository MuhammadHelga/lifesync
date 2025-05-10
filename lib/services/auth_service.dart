import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../theme/AppColors.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Register
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.sendEmailVerification();

      return cred.user;
    } catch (e) {
      debugPrint('Error saat register: $e');
      return null;
    }
  }

  Future<void> saveUserData(String uid, String name, String role) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'role': role,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

  // Login
  Future<User?> loginWithEmail(
    String email,
    String password,
    BuildContext context, {
    required String selectedRole,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      // Ambil data user dari Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email belum diverifikasi. Silakan cek email anda'),
          ),
        );
        return null;
      }
      ;

      String storedRole = userDoc['role'];

      if (storedRole != selectedRole) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.error300,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Email atau Password salah',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        return null;
      }

      return user;
    } catch (e) {
      debugPrint('Error saat login: $e');
      return null;
    }
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error saat mengirim email reset password: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Update Nama dan Email
  Future<String?> updateUserEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        return 'Verifikasi telah dikirim ke email baru. Silakan cek dan konfirmasi.';
      } else {
        return 'User tidak ditemukan.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Silakan login ulang untuk mengubah email.';
      }
      return 'Gagal mengubah email: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  // Tambah kelas
  Future<String> simpanKelas({
    required String namaKelas,
    required String ruangan,
    required String tahunAjaran,
  }) async {
    String _generateKodeKelas({int length = 6}) {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = DateTime.now().millisecondsSinceEpoch;
      return List.generate(
        length,
        (index) => chars[(random + index * 17) % chars.length],
      ).join();
    }

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login');
    }

    final String kodeKelas = _generateKodeKelas();

    try {
      final docRef = await _firestore.collection('kelas').add({
        'kode_kelas': kodeKelas,
        'nama_kelas': namaKelas,
        'ruangan': ruangan,
        'tahun_ajaran': tahunAjaran,
        'dibuat_oleh': user.uid,
        'dibuat_pada': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint('Error saat menyimpan kelas: $e');
      throw e;
    }
  }

  //Tambah Anak
  Future<void> tambahAnak({
    required String name,
    required String gender,
    required String classId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('kelas')
          .doc(classId)
          .collection('anak')
          .add({
            'name': name,
            'gender': gender,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('Error saat menambah anak: $e');
      throw e; // Melempar kembali error jika terjadi
    }
  }
}
