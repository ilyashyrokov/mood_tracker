import 'package:flutter/material.dart';

enum Emotions {
  joy(
    name: 'Радость',
    color: Colors.amber,
  ),
  sadness(
    name: 'Грусть',
    color: Colors.blue,
  ),
  anger(
    name: 'Злость',
    color: Colors.red,
  ),
  neutral(
    name: 'Нейтральное',
    color: Colors.blueGrey,
  ),
  worry(
    name: 'Волнение',
    color: Colors.deepOrange,
  ),
  fear(
    name: 'Страх',
    color: Colors.grey,
  ),
  inspiration(
    name: 'Воодушевленность',
    color: Colors.deepPurple,
  );

  final String name;
  final Color color;

  const Emotions({
    required this.name,
    required this.color,
  });

}

extension EmotionsWidgets on Emotions {
  Widget ovalButton({
    required VoidCallback onPressed,
    bool isSelected = false,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    double borderRadius = 50,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withOpacity(0.15),
        foregroundColor: isSelected ? Colors.white : color,
        shadowColor: color,
        padding: padding,
        shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(
          color: isSelected ? color : color.withOpacity(0.3),
          width: 1.5,
        ),
        elevation: isSelected ? 5 : 0,
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}