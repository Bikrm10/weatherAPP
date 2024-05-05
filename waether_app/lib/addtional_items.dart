import 'package:flutter/material.dart';

class AdditionalItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
 const AdditionalItems({
    super.key,

    required this.icon,
    required this.label,
    required this.value

    });

  @override
  Widget build(BuildContext context) {
    return  Column(
            children: [
            Icon(icon),
            const SizedBox(height: 10,),
            Text(label,
            style:const TextStyle(fontSize: 12,
            ),
            ),
            const SizedBox(height: 10,),
            Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 16),
            ),
             ]
            
          );
  }
}