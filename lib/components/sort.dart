import 'package:flutter/material.dart';

import '../services/notes.dart';


class SortWidget extends StatefulWidget {
  final SortBy sortBy;
  final SortOrder sortOrder;
  final Function handleSortByChange;
  final Function handleSortOrderChange;

  const SortWidget(this.sortBy, this.sortOrder, this.handleSortByChange, this.handleSortOrderChange, {Key? key}) : super(key: key);

  @override
  State<SortWidget> createState() => _SortWidget(sortBy, sortOrder);
}

class _SortWidget extends State<SortWidget> {

  SortBy sortBy;
  SortOrder sortOrder;

  _SortWidget(this.sortBy, this.sortOrder);

  void handleSort() {
    widget.handleSortByChange(sortBy);
    widget.handleSortOrderChange(sortOrder);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Modified At'),
              leading: Radio<SortBy>(
                value: SortBy.modifiedAt,
                groupValue: sortBy,
                onChanged: (SortBy? value) {
                  setState(() {
                    sortBy = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Title'),
              leading: Radio<SortBy>(
                value: SortBy.title,
                groupValue: sortBy,
                onChanged: (SortBy? value) {
                  setState(() {
                    sortBy = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Ascending'),
              leading: Radio<SortOrder>(
                value: SortOrder.ascending,
                groupValue: sortOrder,
                onChanged: (SortOrder? value) {
                  setState(() {
                    sortOrder = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Descending'),
              leading: Radio<SortOrder>(
                value: SortOrder.descending,
                groupValue: sortOrder,
                onChanged: (SortOrder? value) {
                  setState(() {
                    sortOrder = value!;
                  });
                },
              ),
            ),
            FlatButton(
                onPressed: () => handleSort(),
                child: const Text("Confirm")
            )
          ],
        ),
      ),
    );
  }
}



