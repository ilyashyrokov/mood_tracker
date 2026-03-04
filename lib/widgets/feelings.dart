import 'package:flutter/material.dart';
import '../models/emotions.dart';

class Feelings extends StatelessWidget {
  final String title;
  final String? description;
  final Emotions emotion;
  final VoidCallback? onTap;
final VoidCallback? onEditTap;

  const Feelings({
    this.onTap,
    super.key,
    required this.title,
    this.description,
    required this.emotion,
    this.onEditTap,
  }
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: emotion.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: emotion.color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: emotion.color.withOpacity(0.2),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            visualDensity: VisualDensity.comfortable,
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:emotion.color.withOpacity(0.9),
              ),
            ),
            subtitle: Text(
              description ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: onEditTap,
              icon: Icon(
                Icons.edit,
                color: emotion.color.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
