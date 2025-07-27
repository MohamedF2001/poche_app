import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.color = Colors.black,
    required this.icon,
    required this.label,
  });
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final colorA = color.withOpacity(0.6);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: colorA,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            label,
            style: TextStyle(
              color: colorA,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
