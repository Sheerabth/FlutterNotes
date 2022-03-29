import 'package:flutter/material.dart';

import 'package:flutter_notes/services/notes.dart';
import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_theme.dart';
import 'package:flutter_notes/components/notes_list.dart';
import 'package:flutter_notes/components/sort.dart';

// Home Screen
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  late List<Map<String, dynamic>> notesData;
  List<int> selectedNoteIds = [];
  SortBy sortBy = SortBy.modifiedAt;
  SortOrder sortOrder = SortOrder.descending;

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

  void handleSortByChange(SortBy updatedSortBy) {
    setState(() {
      sortBy = updatedSortBy;
    });
  }

  void handleSortOrderChange(SortOrder updatedSortOrder) {
    setState(() {
      sortOrder = updatedSortOrder;
    });
  }

  void handleSort() {
    showDialog(
        context: context,
        builder: (context) => SortWidget(
            sortBy, sortOrder, handleSortByChange, handleSortOrderChange));
  }

  Future<List<Map<String, dynamic>>> handleRead() async {
    try {
      return NotesService.getNotes(sortBy, sortOrder);
    } catch (e) {
      debugPrint('Error retrieving notes');
      return [{}];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      home: Scaffold(
        backgroundColor: const Color(c6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(c7),
          brightness: Brightness.dark,
          title: const Text(
            'Flutter Notes',
            style: TextStyle(
              color: Color(c1),
            ),
          ),
          actions: [
            (selectedNoteIds.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color(c1),
                    ),
                    tooltip: 'Delete',
                    onPressed: () => handleDelete(),
                  )
                : Container()),
            IconButton(
                icon: const Icon(
                  Icons.sort,
                  color: Color(c1),
                ),
                onPressed: () => handleSort()),
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
              MaterialPageRoute(
                  builder: (context) => const NotesEdit(args: ['new', {}])),
            ).then((dynamic value) => {afterNavigatorPop()})
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
