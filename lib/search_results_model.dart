import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResult {
  final String title;
  final String description;
  final String imageUrl;
  final String webUrl;
  SearchResult({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.webUrl,
  });
}

class SearchResultsModel extends ChangeNotifier {
  List<SearchResult> _results = [];

  List<SearchResult> get results => _results;

  Future<List<SearchResult>> fetchResults(String query) async {
    var baseUrl = 'https://en.wikipedia.org';
    // https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10
    var headers = {
      'Cache-Control': 'max-age=3600', // Cache for 1 hour
    };

    final response = await http.get(
      Uri.parse(
          '$baseUrl//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$query&gpslimit=10'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> pages = data['query']['pages'];

      _results = pages.map((page) {
        String newVariable = page['title'];

        return SearchResult(
          title: page['title'],
          description: page['terms'] != null
              ? page['terms']['description'][0]
              : "No Description Available",
          imageUrl: page['thumbnail'] != null
              ? page['thumbnail']['source']
              : 'https://drive.google.com/uc?id=1sO9opy0SAJPtsIK0BT0cLZmUSGbRQ4rY',
          webUrl: 'https://en.wikipedia.org/wiki/$newVariable',
        );
      }).toList();

      notifyListeners();
      return _results; //
    } else {
      throw Exception('Failed to load results');
    }
  }
}
