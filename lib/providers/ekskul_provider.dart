import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final ekskulProvider =
    StateNotifierProvider<
      EkskulNotifier,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) => EkskulNotifier());

class EkskulNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  EkskulNotifier() : super(const AsyncLoading()) {
    fetchEkskul();
  }

  final collection = FirebaseFirestore.instance.collection("ekskul");

  Future<void> fetchEkskul() async {
    try {
      final data = await collection
          .orderBy("createdAt", descending: true)
          .get();
      state = AsyncData(
        data.docs.map((e) => {"id": e.id, ...e.data()}).toList(),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> addEkskul(Map<String, dynamic> data) async {
    await collection.add({
      ...data,
      "createdAt": DateTime.now().toIso8601String(),
    });
    fetchEkskul();
  }

  Future<void> updateEkskul(String id, Map<String, dynamic> data) async {
    await collection.doc(id).update(data);
    fetchEkskul();
  }

  Future<void> deleteEkskul(String id) async {
    await collection.doc(id).delete();
    fetchEkskul();
  }
}
