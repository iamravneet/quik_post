import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(String message, String username) async {
    await _firestore.collection("posts").add({
      "message": message,
      "username": username,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore.collection("posts").orderBy("timestamp", descending: true).snapshots();
  }

}
