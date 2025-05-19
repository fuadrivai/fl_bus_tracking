import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final double? width;
  final String label;
  const CustomButton({super.key, this.onTap, this.width, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
