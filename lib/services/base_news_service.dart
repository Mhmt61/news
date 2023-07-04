import 'package:dio/dio.dart';

import '../api_key.dart';

abstract class BaseNewsService {
  final String baseURL = 'https://newsapi.org/v2';
  final String newsAPIKey = newsApiKey;
  late final BaseOptions options;

  BaseNewsService() {
    options = BaseOptions(
      baseUrl: baseURL,
      headers: <String, dynamic>{'X-Api-Key': newsAPIKey},
    );
  }
}
