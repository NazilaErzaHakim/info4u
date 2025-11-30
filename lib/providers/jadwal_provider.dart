import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final jadwalProvider =
    StateNotifierProvider<JadwalNotifier, List<Map<String, dynamic>>>(
      (ref) => JadwalNotifier(),
    );

class JadwalNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  JadwalNotifier() : super([]);

  Stream<List<DocumentSnapshot>> streamJadwal() {
    return FirebaseFirestore.instance
        .collection("jadwal")
        .snapshots()
        .map((snap) => snap.docs);
  }

  Future<void> addJadwal(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("jadwal").add(data);
  }

  Future<void> updateJadwal(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("jadwal").doc(id).update(data);
  }

  Future<void> deleteJadwal(String id) async {
    await FirebaseFirestore.instance.collection("jadwal").doc(id).delete();
  }
}
