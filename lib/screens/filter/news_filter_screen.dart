import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/providers/filter_provider.dart';
import 'package:news/screens/filter/category_filter_screen.dart';
import 'package:news/screens/filter/country_filter_screen.dart';
import 'package:news/screens/filter/language_filter_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/news_provider.dart';

class NewsFilterScreen extends StatelessWidget {
  const NewsFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var np = Provider.of<NewsProvider>(context, listen: false);
    return Consumer<FilterProvider>(
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Filter'),
          ),
          if (np.isSearching == false)
            ListTile(
              leading: const Icon(Icons.flag),
              trailing: Text(value.filter.country ?? 'All'),
              title: const Text('Country'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const CountryFilterScreen();
                  },
                );
              },
            ),
          if (np.isSearching == false)
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Category'),
              trailing: Text(value.filter.category ?? 'All'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const CategoryFilterScreen();
                  },
                );
              },
            ),
          if (np.isSearching)
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: Text(value.filter.language ?? 'All'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const LanguageFilterScreen();
                  },
                );
              },
            ),
          if (np.isSearching)
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Date'),
              trailing: Text(value.filter.from != null
                  ? '${value.filter.from}-${value.filter.to}'
                  : ''),
              onTap: () async {
                var result = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 7)),
                  lastDate: DateTime.now(),
                );

                var format = DateFormat.yMd();

                if (result != null) {
                  value.filter.from =
                      format.format(result.start).replaceAll('/', '-');
                  value.filter.to =
                      format.format(result.end).replaceAll('/', '-');
                  value.updateFilter();
                }
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  value.reset();
                },
                child: const Text('Reset'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  value.filter.page = 1;
                  np.getArticles(value.filter, isFilter: true);

                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
