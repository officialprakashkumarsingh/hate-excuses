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

  factory WebSearchResult.fromJson(List<dynamic> jsonList) {
    final List<WebPageResult> webPages = [];
    final List<NewsArticleResult> newsArticles = [];
    final List<ImageResult> images = [];

    for (var item in jsonList) {
      if (item is Map<String, dynamic>) {
        // Differentiate based on keys
        if (item.containsKey('snippet')) {
          webPages.add(WebPageResult.fromJson(item));
        } else if (item.containsKey('source')) {
          newsArticles.add(NewsArticleResult.fromJson(item));
        } else if (item.containsKey('imageUrl') && item.keys.length <= 2) {
          // Assuming items with only imageUrl and link are images
          images.add(ImageResult.fromJson(item));
        }
      }
    }

    return WebSearchResult(
      webPages: webPages,
      newsArticles: newsArticles,
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'web_results': webPages.map((item) => item.toJson()).toList(),
      'news_results': newsArticles.map((item) => item.toJson()).toList(),
      'image_results': images.map((item) => item.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'snippet': snippet,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'source': source,
      'imageUrl': imageUrl,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'imageUrl': imageUrl,
    };
  }
}
