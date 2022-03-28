import 'package:flutter/material.dart';

import 'package:flutter_notes/screens/update.dart';
import 'package:flutter_notes/theme/note_colors.dart';

class AllNoteLists extends StatelessWidget {
  final dynamic data;
  final List<int> selectedNoteIds;
  final dynamic afterNavigatorPop;
  final dynamic handleNoteListLongPress;
  final dynamic handleNoteListTapAfterSelect;

  const AllNoteLists({Key? key, this.data, required this.selectedNoteIds, this.afterNavigatorPop, this.handleNoteListLongPress, this.handleNoteListTapAfterSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        dynamic item = data[index];
        return DisplayNotes(
            notesData: item,
            selectedNoteIds: selectedNoteIds,
            selectedNote: (selectedNoteIds.contains(item['id']) == false? false : true),
            callAfterNavigatorPop: afterNavigatorPop,
            handleNoteListLongPress: handleNoteListLongPress,
            handleNoteListTapAfterSelect: handleNoteListTapAfterSelect
        );
      },
    );
  }
}


class DisplayNotes extends StatelessWidget {
  final dynamic notesData;
  final List<int> selectedNoteIds;
  final bool selectedNote;
  final dynamic callAfterNavigatorPop;
  final dynamic handleNoteListLongPress;
  final dynamic handleNoteListTapAfterSelect;

  const DisplayNotes({Key? key, this.notesData, required this.selectedNoteIds, required this.selectedNote, this.callAfterNavigatorPop, this.handleNoteListLongPress, this.handleNoteListTapAfterSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        color: (selectedNote == false? const Color(c1): const Color(c8)),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            if (selectedNote == false) {
              if (selectedNoteIds.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotesEdit(args: ['update', notesData]),
                  ),
                ).then((dynamic value) => {
                  callAfterNavigatorPop()
                });
                return;
              } else {
                handleNoteListLongPress(notesData['id']);
              }
            } else {
              handleNoteListTapAfterSelect(notesData['id']);
            }
          },

          onLongPress: () {
            handleNoteListLongPress(notesData['id']);
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
                          color: (selectedNote == false?
                          Color(noteColors[notesData['noteColor']]!['b']!):
                          const Color(c9)
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: (
                              selectedNote == false?
                              Text(
                                notesData['title'][0],
                                style: const TextStyle(
                                  color: Color(c1),
                                  fontSize: 21,
                                ),
                              ):
                              const Icon(
                                Icons.check,
                                color: Color(c1),
                                size: 21,
                              )
                          ),
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
                        notesData['title'] ?? "",
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
                        notesData['content'] != null? notesData['content'].split('\n')[0]: "",
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