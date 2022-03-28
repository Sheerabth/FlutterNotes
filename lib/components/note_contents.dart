import 'package:flutter/material.dart';

import '../theme/note_theme.dart';


class NoteTitleEntry extends StatelessWidget {
  final TextEditingController textFieldController;

  const NoteTitleEntry({Key? key, required this.textFieldController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textFieldController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
        counter: null,
        counterText: "",
        hintText: 'Title',
        hintStyle: TextStyle(
          color: Color(c1),
          fontSize: 21,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
      maxLength: 31,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: Color(c1),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}


class NoteEntry extends StatelessWidget {
  final TextEditingController textFieldController;

  const NoteEntry({Key? key, required this.textFieldController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: TextField(
        controller: textFieldController,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: null,
        style: const TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}
