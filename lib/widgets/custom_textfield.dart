import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            label: Text(label),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
