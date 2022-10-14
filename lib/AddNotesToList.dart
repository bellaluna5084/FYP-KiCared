import 'package:firebase_database/firebase_database.dart';
import 'package:kicaredfinal/Notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
// var currentUser = FirebaseAuth.instance.currentUser;
class MessageDao {
  final DatabaseReference _notesRef = FirebaseDatabase.instance.ref().child('diary').child(FirebaseAuth.instance.currentUser!.uid);
  void saveNotes(NotesOfApp notes) {
    _notesRef.push().set(notes.toJson());
  }
  Query getNotesQuery() {
    return _notesRef;
  }
}