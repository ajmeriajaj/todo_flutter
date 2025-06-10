import 'package:flutter/material.dart';
import 'package:todo_flutter/responsive.dart';

class FilterWidgets extends StatefulWidget {
  final String fills;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterWidgets({
    super.key,
    required this.fills,
    required this.isSelected,
    required this.onTap
  });

  @override
  State<FilterWidgets> createState() => _FilterWidgetsState();
}

class _FilterWidgetsState extends State<FilterWidgets> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: widget.isSelected ? Colors.amber : Colors.white,
        elevation: 10,
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 10 * getResponsive(context),
            vertical: 5 * getResponsive(context),
          ),
          child: Text(widget.fills),
        ),
      ),
    );
  }
}
