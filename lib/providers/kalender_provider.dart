import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

final kalenderProvider =
    StateNotifierProvider<
      KalenderNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) => KalenderNotifier());

class KalenderNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  KalenderNotifier() : super(const AsyncValue.loading()) {
    getKalender();
  }

  final _db = FirebaseFirestore.instance.collection("kalender");

  Future<void> getKalender() async {
    state = const AsyncValue.loading();
    final data = await _db.orderBy("createdAt", descending: true).get();
    state = AsyncValue.data(
      data.docs.map((e) => {"id": e.id, ...e.data()}).toList(),
    );
  }

  Future<void> addKalender(Map<String, dynamic> data) async {
    await _db.add(data);
    getKalender();
  }

  Future<void> updateKalender(String id, Map<String, dynamic> data) async {
    await _db.doc(id).update(data);
    getKalender();
  }

  Future<void> deleteKalender(String id) async {
    await _db.doc(id).delete();
    getKalender();
  }
}
