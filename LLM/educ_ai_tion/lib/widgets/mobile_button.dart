import 'package:flutter/material.dart';

class MobileButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const MobileButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 203, 115, 221),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(imagePath, width: 90, height: 90),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ), // Label
            ],
          ),
        ),
      ),
    );
  }
}
