import 'package:flutter/material.dart';
import 'package:flutter_notes/models/access_type.dart';
import '../theme/note_theme.dart';

class ChangeAccess extends StatefulWidget {
  final String noteColor;
  final AccessType accessRights;
  final List<AccessType> availableAccessTypes = AccessType.values;

  ChangeAccess({Key? key, required this.noteColor, required this.accessRights})
      : super(key: key) {
    availableAccessTypes.remove(AccessType.owner);
  }

  @override
  _ChangeAccess createState() => _ChangeAccess();
}

class _ChangeAccess extends State<ChangeAccess> {
  late AccessType accessRights;

  @override
  void initState() {
    super.initState();
    accessRights = widget.accessRights;
  }

  Future<void> changeAccess(AccessType accessRights) async {
    setState(() {
      accessRights = accessRights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(noteColors[widget.noteColor]!['b']!),
        title: const Text('Share Note'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: widget.availableAccessTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(widget.availableAccessTypes[index].name)
                                  )
                              ),
                              accessRights == widget.availableAccessTypes[index] ?
                              const Expanded(
                                flex: 1,
                                child: Icon(Icons.delete),
                              ) : const Text(''),
                            ],
                          ),
                          onTap: () => {changeAccess(widget.availableAccessTypes[index])},
                        )
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
