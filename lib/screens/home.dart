import 'package:flutter/material.dart';

import 'package:flutter_notes/services/notes.dart';
import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_theme.dart';
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
      await NotesService.deleteNote(selectedNoteIds);
    } catch (e) {
      debugPrint('Db error');
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  // Widget _buildPopupDialog(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text('Popup example'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: const <Widget>[
  //         Text("Hello"),
  //       ],
  //     ),
  //     actions: <Widget>[
  //       FlatButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //         textColor: Theme.of(context).primaryColor,
  //         child: const Text('Close'),
  //       ),
  //     ],
  //   );
  // }

  void handleSort() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => _buildPopupDialog(context),
    // );
  }

  Future<List<Map<String, dynamic>>> handleRead({String sortBy = "date"}) async {
    try {
      return NotesService.getNotes(sortBy);
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
          backgroundColor: const Color(c7),
          brightness: Brightness.dark,
          
          title: const Text(
            'Super Note',
            style: TextStyle(
              color: Color(c1),
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
              onPressed: () => handleSort()
            ),
          ],
        ),
        // Floating Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Color(c1),
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
