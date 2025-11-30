import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final guruProvider =
    StateNotifierProvider<GuruProvider, List<Map<String, dynamic>>>(
      (ref) => GuruProvider(),
    );

class GuruProvider extends StateNotifier<List<Map<String, dynamic>>> {
  GuruProvider() : super([]);

  final CollectionReference guruRef = FirebaseFirestore.instance.collection(
    "guru",
  );

  // STREAM REALTIME
  Stream<List<DocumentSnapshot>> streamGuru() {
    return guruRef.orderBy("createdAt", descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs;
    });
  }

  // ADD GURU
  Future<void> addGuru({
    required String nama,
    required String nip,
    required String mapel,
    required String email,
    required String noHp,
    required String fotoUrl,
  }) async {
    await guruRef.add({
      "nama": nama,
      "nip": nip,
      "mapel": mapel,
      "email": email,
      "noHp": noHp,
      "fotoUrl": fotoUrl,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // DELETE
  Future<void> deleteGuru(String id) async {
    await guruRef.doc(id).delete();
  }
}
