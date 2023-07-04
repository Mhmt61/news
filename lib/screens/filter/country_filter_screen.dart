import 'package:flutter/material.dart';
import 'package:news/enums.dart';
import 'package:news/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class CountryFilterScreen extends StatelessWidget {
  const CountryFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: Country.values
          .map(
            (e) => ListTile(
              leading: const Icon(Icons.flag),
              title: Text(e.name),
              onTap: () {
                Provider.of<FilterProvider>(context, listen: false)
                    .filter
                    .country = e.name;
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
