import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final galeriProvider =
    StateNotifierProvider<
      GaleriProvider,
      AsyncValue<List<Map<String, dynamic>>>
    >((ref) => GaleriProvider());

class GaleriProvider
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  GaleriProvider() : super(const AsyncLoading()) {
    getGaleri();
  }

  final collection = FirebaseFirestore.instance.collection("galeri");

  Future<void> getGaleri() async {
    try {
      final snapshot = await collection
          .orderBy("createdAt", descending: true)
          .get();
      final data = snapshot.docs.map((e) => {"id": e.id, ...e.data()}).toList();

      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addGaleri(Map<String, dynamic> data) async {
    await collection.add({...data, "createdAt": DateTime.now()});
    getGaleri();
  }

  Future<void> updateGaleri(String id, Map<String, dynamic> data) async {
    await collection.doc(id).update(data);
    getGaleri();
  }

  Future<void> deleteGaleri(String id) async {
    await collection.doc(id).delete();
    getGaleri();
  }
}
