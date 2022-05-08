import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/models/access_type.dart';
import 'package:uuid_type/uuid_type.dart';
import '../theme/note_theme.dart';
import '../models/note.dart';
import '../dao/notes.dart';
import 'package:tuple/tuple.dart';

class ShareNote extends StatefulWidget {
  final String noteColor;
  final Note note;
  final AccessType accessRights;

  const ShareNote({Key? key, required this.noteColor, required this.note, required this.accessRights})
      : super(key: key);

  @override
  _ShareNote createState() => _ShareNote();
}

class _ShareNote extends State<ShareNote> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  Future<void> shareNote(Uuid id, String email) async {
    List<String> sharedUsers = await NotesDAO.getSharedEmails(id);
    if (sharedUsers.contains(email) || email == FirebaseAuth.instance.currentUser!.email) {
      const snackBar = SnackBar(
        content: Text('Access already exists for this user'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    await NotesDAO.shareNote(id, email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(noteColors[widget.noteColor]!['b']!),
        title: const Text('Share Note'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be blank';
                        }
                        if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        }
                        return "Enter a valid email";
                      },
                      controller: emailController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await shareNote(
                            widget.note.id, emailController.text);
                        emailController.clear();
                        setState(() {});
                      }
                    },
                    child: const Text("Invite"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<Tuple2<String, AccessType>>>(
              future: NotesDAO.getAccessRights(widget.note.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(noteColors[
                                            widget.noteColor]!['b']!),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          snapshot.data[index].item1[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(c1),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(snapshot.data[index].item1))),
                                  snapshot.data[index].item2 != AccessType.owner && widget.accessRights == AccessType.owner?
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await NotesDAO.revokeNoteAccess(
                                            widget.note.id,
                                            snapshot.data[index].item1);
                                        setState(() {});
                                      },
                                    ),
                                  ) : const Text(''),
                                ],
                              )),
                        );
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
