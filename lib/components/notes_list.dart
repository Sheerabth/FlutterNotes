import 'package:flutter/material.dart';

import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_theme.dart';
import 'package:uuid_type/uuid_type.dart';

import '../models/user_note.dart';

import '../dao/cloud_storage.dart';

class AllNoteLists extends StatelessWidget {
  final List<UserNote> data;
  final List<Uuid> selectedNoteIds;
  final dynamic afterNavigatorPop;
  final dynamic handleNoteListLongPress;
  final dynamic handleNoteListTapAfterSelect;

  const AllNoteLists(
      {Key? key,
      required this.data,
      required this.selectedNoteIds,
      this.afterNavigatorPop,
      this.handleNoteListLongPress,
      this.handleNoteListTapAfterSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        UserNote item = data[index];
        return DisplayNote(
            noteData: item,
            selectedNoteIds: selectedNoteIds,
            selectedNote:
                (selectedNoteIds.contains(item.id) == false ? false : true),
            callAfterNavigatorPop: afterNavigatorPop,
            handleNoteListLongPress: handleNoteListLongPress,
            handleNoteListTapAfterSelect: handleNoteListTapAfterSelect);
      },
    );
  }
}

class DisplayNote extends StatelessWidget {
  final UserNote noteData;
  final List<Uuid> selectedNoteIds;
  final bool selectedNote;
  final dynamic callAfterNavigatorPop;
  final dynamic handleNoteListLongPress;
  final dynamic handleNoteListTapAfterSelect;

  const DisplayNote(
      {Key? key,
      required this.noteData,
      required this.selectedNoteIds,
      required this.selectedNote,
      this.callAfterNavigatorPop,
      this.handleNoteListLongPress,
      this.handleNoteListTapAfterSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        color: (selectedNote == false ? const Color(c1) : const Color(c8)),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () async {
            if (selectedNote == false) {
              if (selectedNoteIds.isEmpty) {
                noteData.content = await CloudStorage.getNote(noteData.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesEdit(noteData: noteData),
                  ),
                ).then((dynamic value) => {callAfterNavigatorPop()});
                return;
              } else {
                handleNoteListLongPress(noteData.id);
              }
            } else {
              handleNoteListTapAfterSelect(noteData.id);
            }
          },
          onLongPress: () {
            handleNoteListLongPress(noteData.id);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (selectedNote == false
                              ? Color(noteColors[noteData.color]!['b']!)
                              : const Color(c9)),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: (selectedNote == false
                              ? Text(
                                  noteData.title[0],
                                  style: const TextStyle(
                                    color: Color(c1),
                                    fontSize: 21,
                                  ),
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Color(c1),
                                  size: 21,
                                )),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        noteData.title,
                        style: const TextStyle(
                          color: Color(c3),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text(
                        noteData.preview ?? "",
                        style: const TextStyle(
                          color: Color(c7),
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
