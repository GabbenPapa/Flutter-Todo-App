import 'package:flutter/material.dart';
import 'package:todo_app/components/buttons.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAction;
  final VoidCallback onCancel;
  final String text;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onAction,
      required this.onCancel,
      required this.text});

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: "Add new task",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DiagButton(text: widget.text, onPressed: widget.onAction),
                const SizedBox(width: 8),
                DiagButton(text: 'cancel', onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
