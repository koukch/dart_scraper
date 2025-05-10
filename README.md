# dart_scraper

A Dart web scraping library inspired by [scrape-it](https://www.npmjs.com/package/scrape-it).

## Features

- Simple and intuitive API
- CSS selector support
- List item extraction
- Attribute extraction
- Error handling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dart_scraper: ^1.0.0
```

## Usage

```dart
import 'package:dart_scraper/dart_scraper.dart';

void main() async {
  // Simple scraping
  final data = await ScrapeIt.scrape('https://example.com', {
    'title': 'h1',
    'description': 'p',
  });
  print(data); // {title: 'Example Domain', description: 'This domain is...'}

  // Scraping with lists
  final dataWithLists = await ScrapeIt.scrape('https://example.com', {
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
  print(dataWithLists); // {links: [{text: 'More information...', url: 'https://...'}]}
}
```

## Selector Types

### Simple Selector
```dart
'title': 'h1'  // Gets the text of the first h1 element
```

### Complex Selector
```dart
'image': {
  'selector': 'img',
  'attr': 'src'  // Gets the src attribute of the first img element
}
```

### List Selector
```dart
'articles': {
  'listItem': '.article',
  'data': {
    'title': 'h2',
    'content': '.content',
    'image': {
      'selector': 'img',
      'attr': 'src'
    }
  }
}
```

## Error Handling

The library includes built-in error handling for common issues:

- Network errors
- Invalid URLs
- Non-200 status codes
- Missing elements

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
