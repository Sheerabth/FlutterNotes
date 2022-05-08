import 'package:flutter/material.dart';
import 'package:flutter_notes/models/access_type.dart';
import 'package:uuid_type/uuid_type.dart';

import '../models/note.dart';
import '../models/user_note.dart';
import '../theme/note_theme.dart';
import '../components/note_contents.dart';
import '../components/color_picker.dart';
import '../services/notes.dart';
import './share.dart';

class NotesEdit extends StatefulWidget {

  final UserNote? noteData;

  const NotesEdit({Key? key, this.noteData}) : super(key: key);

  @override
  _NotesEdit createState() => noteData != null ? _NotesEdit(noteData: noteData, accessRights: noteData!.accessRights) : _NotesEdit();
}

class _NotesEdit extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'purple';
  bool showShare = false;
  Note? noteData;
  AccessType accessRights;

  _NotesEdit({this.noteData, this.accessRights = AccessType.owner});

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  void handleColor(currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) => {
          if (colorName != null)
            {
              setState(() {
                noteColor = colorName;
              })
            }
        });
  }

  handleSave() async {
    if (noteTitle.isEmpty) {
      // Go back without saving
      if (noteContent.isEmpty) {
        setState(() {
          showShare = false;
        });
        return;
      } else {
        String title = noteContent.split('\n')[0];
        if (title.length > 31) {
          title = title.substring(0, 31);
        }
        setState(() {
          noteTitle = title;
        });
      }
    }

    // Save new note
    if (noteData == null) {
      Note noteObj = Note(id: Uuid.parse(uuid.v4()), title: noteTitle, color: noteColor, lastModified: dateFormat.format(DateTime.now()),content: noteContent);
      await NotesService.insertNote(noteObj);
      noteData = noteObj;
    }

    // Update Note
    else if (noteData != null) {
      Note noteObj = Note(
          id: noteData!.id,
          title: noteTitle,
          color: noteColor,
          lastModified: dateFormat.format(DateTime.now()),
          content: noteContent
      );
      await NotesService.updateNote(noteObj);
      noteData = noteObj;
    }

    setState(() {
      showShare = true;
    });
  }

  handleBackButton() async {
    await handleSave();
    if (noteTitle == '' && noteData != null) {
      await NotesService.deleteNote([noteData!.id]);
    }
    Navigator.pop(context);
  }

  // Share note
  handleShare() async {
    await handleSave();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShareNote(noteColor: noteColor, note: noteData!, accessRights: accessRights)),
    );
  }

  @override
  void initState() {
    super.initState();
    noteTitle = (noteData == null ? '' : noteData!.title);
    noteContent = (noteData == null ? '' : (noteData!.content ?? ''));
    noteColor =
        (noteData == null ? 'purple' : noteData!.color);

    _titleTextController.text =
        (noteData == null ? '' : noteData!.title);
    _contentTextController.text =
        (noteData == null ? '' : noteData!.content ?? '');
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
    showShare = (noteTitle != '');
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(noteColors[noteColor]!['l']!),
      appBar: AppBar(
        backgroundColor: Color(noteColors[noteColor]!['b']!),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(c1),
          ),
          tooltip: 'Back',
          onPressed: () => handleBackButton(),
        ),
        actions: [
          showShare ? IconButton(
            icon: const Icon(
              Icons.share,
              color: Color(c1),
            ),
            tooltip: 'Share',
            onPressed: () => handleShare(),
          ) : const Text(''),

          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: Color(c1),
            ),
            tooltip: 'Color Palette',
            onPressed: () => handleColor(context),
          ),
        ],
        title: NoteTitleEntry(textFieldController: _titleTextController),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
                heroTag: "Cancel Button",
                child: const Icon(
                  Icons.cancel,
                  color: Color(c1),
                ),
                tooltip: 'Cancel',
                backgroundColor: const Color(c2),
                onPressed: () => Navigator.pop(context)
            ),
            FloatingActionButton(
                heroTag: "Save Button",
                child: const Icon(
                  Icons.save,
                  color: Color(c1),
                ),
                tooltip: 'Save',
                backgroundColor: const Color(c3),
                onPressed: () => handleSave()
            ),
          ],
        ),
      ),
      body: NoteEntry(textFieldController: _contentTextController),
    );
  }
}
