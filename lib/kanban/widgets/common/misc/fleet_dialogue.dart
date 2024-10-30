import 'package:fleet/kanban/widgets/common/misc/fleet_close_icon.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

class FleetDialog extends StatefulWidget {
  const FleetDialog({
    super.key, 
    this.message,
    this.onClick,
    this.displayItem,
  });

  final String? message;
  final Function(String)? onClick;
  final Widget? displayItem;

  @override
  State<FleetDialog> createState() => _FleetDialogState();
}

class _FleetDialogState extends State<FleetDialog> {
  bool _yesHovering = false;
  bool _noHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 420, height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
          ),
          child: widget.displayItem == null ? _buildDefaultItems() : _buildDisplayItem()
        )
      ),
    );
  }

  Widget _buildDisplayItem() {
    return widget.displayItem!;
  }

  Widget _buildDefaultItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FleetCloseIcon(),
          ],
        ),
        _message(),
        const Spacer(),
        Row(
          children: [
            _buildOption("yes", _yesHovering, (hovering) {
              setState(() {
                _yesHovering = hovering;
              });
            }),
            _buildOption("no", _noHovering, (hovering) {
              setState(() {
                _noHovering = hovering;
              });
            }),
          ],
        )
      ],
    );
  }

  Widget _message() {
    return Padding(
      padding: const EdgeInsets.only(left: 80, top: 42),
      child: FleetText(
        text: widget.message!,
        colour: const Color.fromARGB(255, 75, 75, 75),
        size: 14,
        weight: FontWeight.w300,
      ),
    );
  }

  Widget _buildOption(String option, bool isHovering, Function(bool) onHover) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.onClick!(option);
          },
          child: SizedBox(
            width: 28,
            child: FleetText(
              text: option,
              colour: Colors.grey,
              size: 14,
              weight: isHovering ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
