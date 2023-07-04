import 'package:flutter/material.dart';
import 'package:news/models/news_service_request.dart';

import '../enums.dart';

class FilterProvider extends ChangeNotifier {
  FilterProvider() {
    _filter.country = Country.tr.name;
  }

  var _filter = NewsServiceRequest();

  void updateFilter() {
    notifyListeners();
  }

  void reset() {
    _filter = NewsServiceRequest();
    notifyListeners();
  }

  NewsServiceRequest get filter => _filter;
}
