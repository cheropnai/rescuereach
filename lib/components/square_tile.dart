import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget{
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath, required child,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 191, 166, 233),
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}