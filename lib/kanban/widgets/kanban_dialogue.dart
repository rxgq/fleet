import 'package:flutter/material.dart';

class KanbanDialog extends StatefulWidget {
  const KanbanDialog({
    super.key, 
    required this.message,
    required this.onClick,
  });

  final String message;
  final Function(String) onClick;

  @override
  State<KanbanDialog> createState() => _KanbanDialogState();
}

class _KanbanDialogState extends State<KanbanDialog> {
  bool _yesHovering = false;
  bool _noHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 320, height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          ),
        )
      ),
    );
  }

  Widget _message() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Text(
        widget.message,
        style: const TextStyle(
          color: Color.fromARGB(255, 75, 75, 75),
          fontSize: 14
        ),
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
            widget.onClick(option);
          },
          child: SizedBox(
            width: 28,
            child: Text(
              option,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: isHovering ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
