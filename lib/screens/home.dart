import 'package:flutter/material.dart';

import 'package:flutter_notes/services/notes.dart';
import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_colors.dart';
import 'package:flutter_notes/components/notes_list.dart';

// Home Screen
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  late List<Map<String, dynamic>> notesData;
  List<int> selectedNoteIds = [];

  void afterNavigatorPop() {
    setState(() {});
  }

  void handleNoteListLongPress(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  void handleNoteListTapAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  void handleDelete() async {
    try {
      NotesService.deleteNote(selectedNoteIds);
    } catch (e) {
      debugPrint('Db error');
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  Future<List<Map<String, dynamic>>> handleRead() async {
    try {
      return NotesService.getNotes();
    } catch (e) {
      debugPrint('Error retrieving notes');
      return [{}];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Note',
      home: Scaffold(
        backgroundColor: const Color(c6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(c2),
          brightness: Brightness.dark,
          
          title: const Text(
            'Super Note',
            style: TextStyle(
              color: Color(c5),
            ),
          ),

          actions: [
            (selectedNoteIds.isNotEmpty?
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(c1),
                ),
                tooltip: 'Delete',
                onPressed: () => handleDelete(),
              ): Container()
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_alt,
                color: Color(c1),
              ),
              onPressed: () => {}
            ),
          ],
        ),
        // Floating Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Color(c5),
          ),
          tooltip: 'New Notes',
          backgroundColor: const Color(c4),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotesEdit(args: ['new', {}])),
            ).then((dynamic value) => {
              afterNavigatorPop()
            })
          },
        ),
        body: FutureBuilder(
          future: handleRead(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              notesData = snapshot.data;
              return Stack(
                children: <Widget>[
                  AllNoteLists(
                    data: snapshot.data,
                    selectedNoteIds: selectedNoteIds,
                    afterNavigatorPop: afterNavigatorPop,
                    handleNoteListLongPress: handleNoteListLongPress,
                    handleNoteListTapAfterSelect: handleNoteListTapAfterSelect,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              debugPrint('Error reading database');
              return const Text('Error');
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(c3),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
