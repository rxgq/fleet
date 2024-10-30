import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

class FleetDropdown extends StatefulWidget {
  const FleetDropdown({
    super.key, 
    required this.items,
    required this.onChange,
    this.selectedItem,
  });

  final List<String> items;
  final Function(String) onChange;
  final String? selectedItem;

  @override
  State<FleetDropdown> createState() => _FleetDropdownState();
}

class _FleetDropdownState extends State<FleetDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedItem ?? (widget.items.isNotEmpty ? widget.items[0] : null);
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
          child: DropdownButton(
            value: _selectedValue,
            isExpanded: false,
            onChanged: (String? newValue) {
              setState(() {
                _selectedValue = newValue;
              });
              if (newValue != null) {
                widget.onChange(newValue);
              }
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: FleetText(
                    text: value, 
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
