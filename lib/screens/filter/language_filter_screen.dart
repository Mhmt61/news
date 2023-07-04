import 'package:flutter/material.dart';
import 'package:news/enums.dart';
import 'package:provider/provider.dart';

import '../../providers/filter_provider.dart';

class LanguageFilterScreen extends StatelessWidget {
  const LanguageFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: Language.values
          .map(
            (e) => ListTile(
              leading: const Icon(Icons.language),
              title: Text(e.name),
              onTap: () {
                context.read<FilterProvider>().filter.language = e.name;
                context.read<FilterProvider>().updateFilter();
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    );
  }
}
