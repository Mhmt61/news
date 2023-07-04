import 'package:flutter/material.dart';
import 'package:news/enums.dart';
import 'package:provider/provider.dart';

import '../../providers/filter_provider.dart';

class CategoryFilterScreen extends StatelessWidget {
  const CategoryFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: NewsCategory.values
          .map(
            (e) => ListTile(
              leading: const Icon(Icons.category),
              title: Text(e.name),
              onTap: () {
                Provider.of<FilterProvider>(context, listen: false)
                    .filter
                    .category = e.name;
                Provider.of<FilterProvider>(context, listen: false)
                    .updateFilter();
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    );
  }
}
