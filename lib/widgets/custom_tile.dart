import "package:flutter/material.dart";

class CustomTile extends StatelessWidget {
  final Key dkey;
  final String title, amountTxt, date;
  final Function onDismissed;
  final int colorValue;

  const CustomTile({
    super.key,
    required this.dkey,
    required this.title,
    required this.amountTxt,
    required this.date,
    required this.colorValue,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dkey,
      background: Container(color: Colors.red),
      onDismissed: (direction) => onDismissed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24.0),
              ),
              Column(
                children: [
                  Text(
                    amountTxt,
                    style: TextStyle(
                      color: Color(colorValue),
                      fontSize: 24.0,
                    ),
                  ),
                  Text(date),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
