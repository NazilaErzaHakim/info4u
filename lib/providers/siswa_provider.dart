import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final siswaProvider =
    StateNotifierProvider<
      SiswaNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) => SiswaNotifier());

class SiswaNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  SiswaNotifier() : super(const AsyncValue.loading()) {
    getAllSiswa();
  }

  Future<void> getAllSiswa() async {
    try {
      final query = await FirebaseFirestore.instance.collection("siswa").get();
      final data = query.docs.map((e) {
        final dt = e.data();
        dt["id"] = e.id;
        return dt;
      }).toList();

      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSiswa({
    required String nis,
    required String nama,
    required String kelas,
    required String email,
    required String noHp,
  }) async {
    await FirebaseFirestore.instance.collection("siswa").add({
      "nis": nis,
      "nama": nama,
      "kelas": kelas,
      "email": email,
      "noHp": noHp,
    });
    getAllSiswa();
  }

  Future<void> deleteSiswa(String id) async {
    await FirebaseFirestore.instance.collection("siswa").doc(id).delete();
    getAllSiswa();
  }
}
