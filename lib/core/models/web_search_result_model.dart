import 'package:flutter/foundation.dart';

class WebSearchResult {
  final List<WebPageResult> webPages;
  final List<NewsArticleResult> newsArticles;
  final List<ImageResult> images;

  WebSearchResult({
    required this.webPages,
    required this.newsArticles,
    required this.images,
  });

  factory WebSearchResult.fromJson(Map<String, dynamic> json) {
    return WebSearchResult(
      webPages: (json['web_results'] as List? ?? [])
          .map((item) => WebPageResult.fromJson(item))
          .toList(),
      newsArticles: (json['news_results'] as List? ?? [])
          .map((item) => NewsArticleResult.fromJson(item))
          .toList(),
      images: (json['image_results'] as List? ?? [])
          .map((item) => ImageResult.fromJson(item))
          .toList(),
    );
  }
}

class WebPageResult {
  final String title;
  final String link;
  final String snippet;

  WebPageResult({
    required this.title,
    required this.link,
    required this.snippet,
  });

  factory WebPageResult.fromJson(Map<String, dynamic> json) {
    return WebPageResult(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      snippet: json['snippet'] ?? '',
    );
  }
}

class NewsArticleResult {
  final String title;
  final String link;
  final String source;
  final String imageUrl;

  NewsArticleResult({
    required this.title,
    required this.link,
    required this.source,
    required this.imageUrl,
  });

  factory NewsArticleResult.fromJson(Map<String, dynamic> json) {
    return NewsArticleResult(
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      source: json['source'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class ImageResult {
  final String link;
  final String imageUrl;

  ImageResult({
    required this.link,
    required this.imageUrl,
  });

  factory ImageResult.fromJson(Map<String, dynamic> json) {
    return ImageResult(
      link: json['link'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
