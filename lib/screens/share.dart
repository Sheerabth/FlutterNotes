import 'package:flutter/material.dart';
import '../theme/note_theme.dart';
import '../models/note.dart';
import '../dao/notes.dart';

class ShareNote extends StatefulWidget {
  final String noteColor;
  final Note note;

  const ShareNote({Key? key, required this.noteColor, required this.note})
      : super(key: key);

  @override
  _ShareNote createState() => _ShareNote();
}

class _ShareNote extends State<ShareNote> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(noteColors[widget.noteColor]!['b']!),
        title: const Text('Share Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
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
                        await NotesDAO.shareNote(
                            widget.note.id, emailController.text);
                        setState(() {});
                      }
                    },
                    child: const Text("Invite"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<String>>(
              future: NotesDAO.getSharedEmails(widget.note.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
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
                                          snapshot.data[index][0].toUpperCase(),
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
                                          child: Text(snapshot.data[index]))),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await NotesDAO.revokeNoteAccess(
                                            widget.note.id,
                                            snapshot.data[index]);
                                        setState(() {});
                                      },
                                    ),
                                  ),
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
