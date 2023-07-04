import 'package:dio/dio.dart';
import 'package:news/models/news_service_request.dart';
import 'package:news/models/news_service_response.dart';
import 'package:news/services/base_news_service.dart';

import '../enums.dart';

class NewsService extends BaseNewsService {
  late final Dio dio;

  NewsService() {
    dio = Dio(options);
  }

  Future<NewsServiceResponse> getTopHeadlines(NewsServiceRequest filter) async {
    var country = filter.country ?? Country.tr.name;
    var category = filter.category ?? '';
    var q = filter.q ?? '';
    var page = filter.page;
    var pageSize = filter.pageSize;

    var queryString = 'country=$country&category=$category&q=$q&page=$page&'
        'pageSize=$pageSize';

    final response = await dio.get('/top-headlines?$queryString');

    return NewsServiceResponse.fromJson(response.data);
  }

  Future<NewsServiceResponse> searchArticle(NewsServiceRequest filter) async {
    var queryString =
        'q=${filter.q}&page=${filter.page}&pageSize=${filter.pageSize}&'
        'from=${filter.from}&to=${filter.to}';

    final response = await dio.get('/everything?$queryString');

    return NewsServiceResponse.fromJson(response.data);
  }

  Future<NewsServiceResponse> getSources(NewsServiceRequest filter) async {
    var queryString = 'country=${filter.country}&category=${filter.category}'
        '&language=${filter.language}';

    final response = await dio.get('/top-headlines/sources?$queryString');

    return NewsServiceResponse.fromJson(response.data);
  }
}
