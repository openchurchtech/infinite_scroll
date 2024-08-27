import 'package:flutter/material.dart';

class FiltersDialog extends StatefulWidget {
  final void Function(int) onImagesPerPageChanged;
  const FiltersDialog({
    Key? key,
    required this.onImagesPerPageChanged,
  }) : super(key: key);

  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  int _imagesPerPage = 20; // Default value

  @override
  Widget build(BuildContext buildContext) {
    return AlertDialog(
      title: const Text('Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter by text
          Text('Basic Filters:', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 10),
          CheckboxListTile(
            title: Text('Filter 1'),
            value: false, // Implement filter logic here
            onChanged: (bool? value) {
              // Handle filter change
            },
          ),
          CheckboxListTile(
            title: Text('Filter 2'),
            value: false, // Implement filter logic here
            onChanged: (bool? value) {
              // Handle filter change
            },
          ),
          SizedBox(height: 20),
          // Images per page
          Text('Images per Page:',
              style: Theme.of(context).textTheme.headline6),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter number of images per page',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _imagesPerPage = int.parse(value);
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onImagesPerPageChanged(_imagesPerPage);
          },
          child: const Text('Apply'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
