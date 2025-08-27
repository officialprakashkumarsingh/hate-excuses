import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/web_search_result_model.dart';

class WebSearchResultsWidget extends StatelessWidget {
  final WebSearchResult result;
  final String query;

  const WebSearchResultsWidget({
    super.key,
    required this.result,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Web search results for: "$query"',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (result.webPages.isNotEmpty) ...[
            _buildSectionHeader(context, 'Web Pages', CupertinoIcons.globe),
            ...result.webPages.take(3).map((page) => _buildWebPageResult(context, page)),
            const SizedBox(height: 12),
          ],
          if (result.newsArticles.isNotEmpty) ...[
            _buildSectionHeader(context, 'News', CupertinoIcons.news_solid),
            ...result.newsArticles.take(2).map((news) => _buildNewsResult(context, news)),
            const SizedBox(height: 12),
          ],
          if (result.images.isNotEmpty) ...[
            _buildSectionHeader(context, 'Images', CupertinoIcons.photo),
            _buildImageResults(context, result.images),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebPageResult(BuildContext context, WebPageResult page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => _launchURL(page.link),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                page.snippet,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsResult(BuildContext context, NewsArticleResult news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => _launchURL(news.link),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (news.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    news.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        const Icon(CupertinoIcons.news_solid, size: 24),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.source,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageResults(BuildContext context, List<ImageResult> images) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return Card(
            margin: const EdgeInsets.only(right: 8),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              onTap: () => _launchURL(image.link),
              child: Image.network(
                image.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(CupertinoIcons.photo, size: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  }
}
