import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/filter_widgets.dart';

class FilterListView extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterListView({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected
  });

  @override
  State<FilterListView> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {

  List<Map<String, dynamic>> filtersData = [
    {
      'fills': 'All'
    },
    {
      'fills': 'Completed'
    },
    {
      'fills': 'Pending'
    },
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
        itemCount: filtersData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        final filters = filtersData[index];
        return FilterWidgets(
            fills: filters["fills"],
          isSelected: widget.selectedFilter == filters['fills'],
          onTap: () {
            widget.onFilterSelected(filters['fills']);
          },
        );
        }
    );
  }
}
