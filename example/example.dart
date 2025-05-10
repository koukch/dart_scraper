import 'package:dart_scraper/dart_scraper.dart';

void main() async {
  try {
    // Example 1: Simple scraping
    print('Example 1: Simple scraping');
    final simpleData = await ScrapeIt.scrape('https://example.com', {
      'title': 'h1',
      'description': 'p',
    });
    print(simpleData);
    print('\n');

    // Example 2: Scraping with lists
    print('Example 2: Scraping with lists');
    final listData = await ScrapeIt.scrape('https://example.com', {
      'links': {
        'listItem': 'a',
        'data': {
          'text': 'a',
          'url': {
            'selector': 'a',
            'attr': 'href'
          }
        }
      }
    });
    print(listData);
    print('\n');

    // Example 3: Complex scraping
    print('Example 3: Complex scraping');
    final complexData = await ScrapeIt.scrape('https://example.com', {
      'title': 'h1',
      'description': 'p',
      'links': {
        'listItem': 'a',
        'data': {
          'text': 'a',
          'url': {
            'selector': 'a',
            'attr': 'href'
          }
        }
      },
      'image': {
        'selector': 'img',
        'attr': 'src'
      }
    });
    print(complexData);
  } catch (e) {
    print('Error: $e');
  }
} 