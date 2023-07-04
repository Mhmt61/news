import 'package:flutter/material.dart';

import '../models/article.dart';
import '../models/news_service_request.dart';
import '../models/news_service_response.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  var _articles = <Article>[];
  var isSearching = false;

  var isLoading = false;
  var page = 1;
  var hasNextPage = true;

  void notify() {
    notifyListeners();
  }

  void getArticles(NewsServiceRequest filter,
      {bool clearNews = true, bool? isFilter}) async {
    late NewsServiceResponse response;

    if (isSearching) {
      response = await NewsService().searchArticle(filter);
    } else {
      response = await NewsService().getTopHeadlines(filter);
    }

    if (isFilter == true) page = filter.page;
    if ((response.totalResults / filter.pageSize) > page) {
      hasNextPage = true;
      page++;
    } else {
      hasNextPage = false;
    }

    isLoading = false;

    if (clearNews) {
      _articles = response.articles ?? [];
    } else {
      if (response.articles?.isNotEmpty ?? false) {
        _articles.addAll(response.articles!);
      }
    }

    notifyListeners();
  }

  void backArticle() {
    notifyListeners();
  }

  List<Article> get articles => _articles;
}
