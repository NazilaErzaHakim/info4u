import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final pengumumanProvider =
    StateNotifierProvider<PengumumanProvider, List<Map<String, dynamic>>>(
      (ref) => PengumumanProvider(),
    );

class PengumumanProvider extends StateNotifier<List<Map<String, dynamic>>> {
  PengumumanProvider() : super([]);

  final CollectionReference pengumumanRef = FirebaseFirestore.instance
      .collection("pengumuman");

  // STREAM
  Stream<List<DocumentSnapshot>> streamPengumuman() {
    return pengumumanRef
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // ADD
  Future<void> addPengumuman({
    required String judul,
    required String description,
    required String kategori,
    required String dibuatOleh,
    required String gambarUrl,
    required DateTime tanggal,
  }) async {
    await pengumumanRef.add({
      "judul": judul,
      "description": description,
      "kategori": kategori,
      "dibuatOleh": dibuatOleh,
      "gambarUrl": gambarUrl,
      "tanggal": Timestamp.fromDate(tanggal),
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // UPDATE
  Future<void> updatePengumuman(String id, Map<String, dynamic> data) async {
    await pengumumanRef.doc(id).update({
      ...data,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  Future<void> deletePengumuman(String id) async {
    await pengumumanRef.doc(id).delete();
  }
}
