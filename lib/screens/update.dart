import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/note_colors.dart';
import '../components/note_contents.dart';
import '../components/color_picker.dart';
import '../services/notes.dart';

class NotesEdit extends StatefulWidget {
  final List<dynamic> args;

  const NotesEdit({Key? key, required this.args}) : super(key: key);

  @override
  _NotesEdit createState() => _NotesEdit();
}


class _NotesEdit extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'red';

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
      if (colorName != null) {
        setState(() {
          noteColor = colorName;
        })
      }
    });
  }

  handleBackButton() async {
    if (noteTitle.isEmpty) {
      // Go back without saving
      if (noteContent.isEmpty) {
        Navigator.pop(context);
        return;
      }
      else {
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
    if (widget.args[0] == 'new') {
      Note noteObj = Note(
          title: noteTitle,
          content: noteContent,
          noteColor: noteColor
      );
      try {
        await NotesService.insertNote(noteObj);
      } catch (e) {
        debugPrint('Error inserting row');
      } finally {
        Navigator.pop(context);
      }
    }

    // Update Note
    else if (widget.args[0] == 'update') {
      Note noteObj = Note(
        id: widget.args[1]['id'],
        title: noteTitle,
        content: noteContent,
        noteColor: noteColor
      );
      try {
        await NotesService.updateNote(noteObj);
      } catch (e) {
        debugPrint('Error inserting row');
        } finally {
        Navigator.pop(context);
        }
    }

  }

  @override
  void initState() {
    super.initState();
    noteTitle = (widget.args[0] == 'new'? '': widget.args[1]['title']);
    noteContent = (widget.args[0] == 'new'? '': widget.args[1]['content']);
    noteColor = (widget.args[0] == 'new'? 'red': widget.args[1]['noteColor']);


    _titleTextController.text = (widget.args[0] == 'new'? '': widget.args[1]['title']);
    _contentTextController.text = (widget.args[0] == 'new'? '': widget.args[1]['content']);
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
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
              heroTag: "Save Button",
              child: const Icon(
                Icons.cancel,
                color: Color(c5),
              ),
              tooltip: 'Save',
              backgroundColor: const Color(c4),
              onPressed: () => Navigator.pop(context)
            ),
            FloatingActionButton(
                heroTag: "Cancel Button",
                child: const Icon(
                  Icons.done,
                  color: Color(c5),
                ),
                tooltip: 'Save',
                backgroundColor: const Color(c4),
                onPressed: () => handleBackButton()
            ),
          ],
        ),
      ),
      body: NoteEntry(textFieldController: _contentTextController),
    );
  }
}