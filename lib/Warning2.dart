import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Warning2 extends StatelessWidget {

  final List<String> list;
  var PrevTitle;
  Warning2({Key? key, required this.NoteTitle, required this.NoteContent, required this.list, required this.PrevTitle}) : super(key: key);
  final String NoteTitle,NoteContent;
  @override
  Widget build(BuildContext context) {
    return ClassicGeneralDialogWidget(
      titleText: 'Do you want to update?',
      onPositiveClick:(){
      Update(PrevTitle,'$NoteTitle','$NoteContent',list);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } ,
        onNegativeClick: (){
          Navigator.of(context).pop();
        }
    );
  }
}
Future<void> Update(var PrevTitle,String NoteTitle,String NoteContent,List<String> list) async {
  var currentUser = FirebaseAuth.instance.currentUser!;
  String key="";
  String result="";
  final _updates = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('diary').child(currentUser.uid);

  final snapshot = await FirebaseDatabase.instance.ref().child('diary').child(currentUser.uid).get();
  for(DataSnapshot i in snapshot.children ){
    if(i.child('NoteTitle').value.toString()==PrevTitle) {
      key = i.key.toString();
      break;
      }
    }

  await ref.child(key).update({
    "NoteTitle":"$NoteTitle",
    "NoteContent":"$NoteContent",
    "editted":DateTime.now().toIso8601String().split('T').first,
  });
}