import 'package:test/test.dart';
import 'package:dart_scraper/dart_scraper.dart';

void main() {
  group('ScrapeIt', () {
    test('should scrape simple text content', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'title': 'h1',
        'description': 'p',
      });

      expect(data['title'], 'Example Domain');
      expect(data['description'], contains('This domain is for use in illustrative examples'));
    });

    test('should scrape attributes', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'link': {
          'selector': 'a',
          'attr': 'href'
        }
      });

      expect(data['link'], isNotNull);
      expect(data['link'], contains('https://www.iana.org'));
    });

    test('should scrape lists', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
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

      expect(data['links'], isA<List>());
      expect(data['links'].length, greaterThan(0));
      expect(data['links'][0], contains('text'));
      expect(data['links'][0], contains('url'));
    });

    test('should handle nested selectors', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'content': {
          'selector': 'div',
          'data': {
            'title': 'h1',
            'description': 'p'
          }
        }
      });

      expect(data['content'], isNotNull);
      expect(data['content']['title'], isNotNull);
      expect(data['content']['description'], isNotNull);
    });

    test('should handle missing elements gracefully', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'nonexistent': 'div.nonexistent',
        'links': {
          'listItem': 'a.nonexistent',
          'data': {
            'text': 'a'
          }
        }
      });

      expect(data['nonexistent'], isNull);
      expect(data['links'], isEmpty);
    });

    test('should handle invalid URLs', () async {
      expect(
        () => ScrapeIt.scrape('https://nonexistent.example.com', {
          'title': 'h1'
        }),
        throwsException,
      );
    });

    test('should handle non-200 status codes', () async {
      expect(
        () => ScrapeIt.scrape('https://example.com/404', {
          'title': 'h1'
        }),
        throwsException,
      );
    });

    test('should handle complex nested structures', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'main': {
          'selector': 'div',
          'data': {
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
            }
          }
        }
      });

      expect(data['main'], isNotNull);
      expect(data['main']['title'], isNotNull);
      expect(data['main']['description'], isNotNull);
      expect(data['main']['links'], isA<List>());
    });

    test('should handle multiple selectors for the same element', () async {
      final data = await ScrapeIt.scrape('https://example.com', {
        'link': {
          'selector': 'a',
          'attr': 'href'
        },
        'linkText': 'a'
      });

      expect(data['link'], isNotNull);
      expect(data['linkText'], isNotNull);
      expect(data['linkText'], contains('More information'));
    });
  });
} 