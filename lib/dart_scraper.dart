import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

/// A class that provides web scraping functionality similar to scrape-it.
class ScrapeIt {
  /// Scrapes data from a URL using the provided selectors.
  /// 
  /// [url] is the URL to scrape.
  /// [selectors] is a map of selectors to extract data.
  /// 
  /// Example:
  /// ```dart
  /// final data = await ScrapeIt.scrape('https://example.com', {
  ///   'title': 'h1',
  ///   'links': {
  ///     'listItem': 'a',
  ///     'data': {
  ///       'text': 'a',
  ///       'url': {
  ///         'selector': 'a',
  ///         'attr': 'href'
  ///       }
  ///     }
  ///   }
  /// });
  /// ```
  static Future<Map<String, dynamic>> scrape(String url, Map<String, dynamic> selectors) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final document = parser.parse(response.body);
      return _parseSelectors(document, selectors);
    } catch (e) {
      throw Exception('Error scraping website: $e');
    }
  }

  /// Parses the document using the provided selectors.
  static Map<String, dynamic> _parseSelectors(dynamic document, Map<String, dynamic> selectors) {
    final result = <String, dynamic>{};

    selectors.forEach((key, value) {
      if (value is String) {
        // Simple selector
        final elements = _querySelectorAll(document, value);
        if (elements.isNotEmpty) {
          result[key] = elements.first.text;
        } else {
          result[key] = null;
        }
      } else if (value is Map<String, dynamic>) {
        if (value.containsKey('listItem')) {
          // List selector
          result[key] = _parseList(document, value);
        } else if (value.containsKey('selector')) {
          // Complex selector
          if (value.containsKey('data')) {
            // Nested data structure
            final element = _querySelector(document, value['selector']);
            if (element != null) {
              result[key] = _parseSelectors(element, value['data']);
            } else {
              result[key] = null;
            }
          } else {
            result[key] = _parseComplexSelector(document, value);
          }
        }
      }
    });

    return result;
  }

  /// Parses a list of items.
  static List<Map<String, dynamic>> _parseList(dynamic document, Map<String, dynamic> selector) {
    final items = _querySelectorAll(document, selector['listItem']);
    final result = <Map<String, dynamic>>[];

    for (var item in items) {
      final itemData = <String, dynamic>{};
      final data = selector['data'] as Map<String, dynamic>;

      data.forEach((key, value) {
        if (value is String) {
          final element = _querySelector(item, value);
          if (element != null) {
            itemData[key] = element.text;
          } else {
            itemData[key] = null;
          }
        } else if (value is Map<String, dynamic>) {
          if (value.containsKey('attr')) {
            final element = _querySelector(item, value['selector']);
            if (element != null) {
              itemData[key] = element.attributes[value['attr']];
            } else {
              itemData[key] = null;
            }
          } else if (value.containsKey('data')) {
            // Nested data structure in list items
            final element = _querySelector(item, value['selector']);
            if (element != null) {
              itemData[key] = _parseSelectors(element, value['data']);
            } else {
              itemData[key] = null;
            }
          }
        }
      });

      result.add(itemData);
    }

    return result;
  }

  /// Parses a complex selector.
  static dynamic _parseComplexSelector(dynamic document, Map<String, dynamic> selector) {
    if (selector.containsKey('selector')) {
      final element = _querySelector(document, selector['selector']);
      if (element != null) {
        if (selector.containsKey('attr')) {
          return element.attributes[selector['attr']];
        }
        return element.text;
      }
    }
    return null;
  }

  /// Helper method to handle both Document and Element types for querySelector.
  static dom.Element? _querySelector(dynamic document, String selector) {
    if (document is dom.Document) {
      return document.querySelector(selector);
    } else if (document is dom.Element) {
      return document.querySelector(selector);
    }
    return null;
  }

  /// Helper method to handle both Document and Element types for querySelectorAll.
  static List<dom.Element> _querySelectorAll(dynamic document, String selector) {
    if (document is dom.Document) {
      return document.querySelectorAll(selector);
    } else if (document is dom.Element) {
      return document.querySelectorAll(selector);
    }
    return [];
  }
}
