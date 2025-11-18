import 'package:flutter/material.dart';

class FlowSelector<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String hintText;
  final String Function(T) itemTextMapper;
  final void Function(T?) onChanged;

  const FlowSelector({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.itemTextMapper,
    this.hintText = 'Select an item',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: selectedValue,
      hint: Text(hintText),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(itemTextMapper(value)),
        );
      }).toList(),
    );
  }
}
