import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Icon icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width / 2.25,
        child: ElevatedButton.icon(
          icon: icon,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: color),
          label: Text(
            text,
            style: const TextStyle(fontSize: 19.0),
          ),
        ),
      ),
    );
  }
}
