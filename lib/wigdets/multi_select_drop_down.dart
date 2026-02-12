import 'package:flutter/material.dart';

class MultiSelectDropDown extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectDropDown({
    Key? key,
    required this.items,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MultiSelectDropDownState createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Select Items',
      ),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null && !selectedItems.contains(value)) {
          setState(() {
            selectedItems.add(value);
          });
          widget.onSelectionChanged(selectedItems);
        }
      },
    );
  }
}
