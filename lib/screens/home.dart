import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_notes/services/notes.dart';
import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_theme.dart';
import 'package:flutter_notes/components/notes_list.dart';
import 'package:flutter_notes/components/sort.dart';
import 'package:flutter_notes/screens/sigin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid_type/uuid_type.dart';

import '../models/user_note.dart';

// Home Screen
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  late List<UserNote> notesData;
  List<Uuid> selectedNoteIds = [];
  SortBy sortBy = SortBy.modifiedAt;
  SortOrder sortOrder = SortOrder.descending;
  User currentUser = FirebaseAuth.instance.currentUser!;

  void afterNavigatorPop() {
    setState(() {});
  }

  void handleNoteListLongPress(Uuid id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  void handleNoteListTapAfterSelect(Uuid id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  void handleDelete() async {
    print(selectedNoteIds);
    await NotesService.deleteNote(selectedNoteIds);
    setState(() {
      selectedNoteIds = [];
    });
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

  Future<List<UserNote>> handleRead() async {
    return await NotesService.getNotes(sortBy, sortOrder);
  }

  void handleSignOut() async {
    final googleCurrentUser =
        GoogleSignIn().currentUser ?? await GoogleSignIn().signIn();
    if (googleCurrentUser != null) {
      await GoogleSignIn().disconnect();
    }
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
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
          title: Text(
            (currentUser.displayName ?? currentUser.email!) + "'s Notes",
            style: const TextStyle(
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
            Tooltip(
              message: currentUser.displayName ?? currentUser.email,
              child: const Icon(
                Icons.account_circle,
                color: Color(c1),
              ),
            ),
          ],
        ),
        // Floating Button

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "New Note",
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
                        builder: (context) =>
                            const NotesEdit(args: ['new', {}])),
                  ).then((dynamic value) => {afterNavigatorPop()})
                },
              ),
              FloatingActionButton(
                  child: const Icon(
                    Icons.logout,
                    color: Color(c1),
                  ),
                  tooltip: 'Sign out',
                  backgroundColor: const Color(c4),
                  onPressed: () => {handleSignOut()}),
            ],
          ),
        ),
        body: FutureBuilder(
          future: handleRead(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              notesData = snapshot.data;
              return RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    AllNoteLists(
                      data: snapshot.data,
                      selectedNoteIds: selectedNoteIds,
                      afterNavigatorPop: afterNavigatorPop,
                      handleNoteListLongPress: handleNoteListLongPress,
                      handleNoteListTapAfterSelect:
                          handleNoteListTapAfterSelect,
                    ),
                  ],
                ),
                onRefresh: () async {
                  setState(
                    () {},
                  );
                },
              );
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
