import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

class FleetDropdown<T> extends StatefulWidget {
  const FleetDropdown({
    super.key, 
    required this.items,
    required this.onChange,
    required this.itemToString,
    this.selectedItem,
    required this.itemIfNull,
  });

  final List<T> items;
  final T? selectedItem;
  final String Function(T) itemToString;
  final Function(T) onChange;
  final T itemIfNull;

  @override
  State<FleetDropdown<T>> createState() => _FleetDropdownState<T>();
}

class _FleetDropdownState<T> extends State<FleetDropdown<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedItem ?? (widget.items.isNotEmpty ? widget.itemIfNull : null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: DropdownButton<T>(
            value: _selectedValue,
            isExpanded: false,
            onChanged: (T? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              if (newValue != null) {
                widget.onChange(newValue);
              }
            },
            items: widget.items.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: FleetText(
                    text: widget.itemToString(value),
                    size: 14,
                    weight: FontWeight.w300,
                    colour: Colors.grey,
                  ),
                ),
              );
            }).toList(),
            style: const TextStyle(
              color: Colors.black,
            ),
            iconEnabledColor: Colors.grey,
            iconSize: 20,
          ),
        ),
      ),
    );
  }
}
