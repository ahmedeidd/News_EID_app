import 'package:dio/dio.dart';
import 'package:flutter_news_json/models/source_response.dart';

import 'models/article_response.dart';

class NewsRepository
{
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "3c8673ddff2f42eb81b5dfe63aec7be0";
  final Dio _dio = Dio();

  var getSourcesUrl = '$mainUrl/sources';
  var getTopHeadlinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = "$mainUrl/everything";

  //****************************************************************************
  // start get sources
  Future<SourceResponse> getSources() async
  {
    var params = {
      "apiKey": apiKey,
      "language" : "en",
      "country" : "us"
    };
    try
    {
      Response response = await _dio.get(getSourcesUrl, queryParameters: params);
      return SourceResponse.fromJson(response.data);
    }
    catch(error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SourceResponse.withError("$error");
    }
  }
  // end get sources
  //****************************************************************************
  // start get top head lines
  Future<ArticleResponse> getTopHeadlines() async
  {
    var params = {
      "apiKey": apiKey,
      "country" : "us",
    };
    try
    {
      Response response = await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    }
    catch(error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
  // end get top head lines
  //****************************************************************************
  // start search
  Future<ArticleResponse> search(String value) async
  {
    var params = {
      "apiKey": apiKey,
      "q" : value,
      "sortBy": "popularity"};
    try
    {
      Response response = await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    }
    catch (error, stacktrace)
    {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
  // end search
  //****************************************************************************
  // start get hot news
  Future<ArticleResponse> getHotNews() async
  {
    var params = {
      "apiKey": apiKey,
      "q" : "apple",
      "sortBy": "popularity"};
    try {
      Response response = await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
  // end get hot news
  //****************************************************************************
  // start get source news
  Future<ArticleResponse> getSourceNews(String sourceId) async
  {
    var params = {
      "apiKey": apiKey,
      "sources" : sourceId};
    try {
      Response response = await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
  // end get source news
  //****************************************************************************
}