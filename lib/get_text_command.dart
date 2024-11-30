import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/src/common/find.dart';
import 'package:flutter_driver/src/common/message.dart';
import 'package:flutter_test/flutter_test.dart';

class Base64URL {
  static String encode(String str) {
    String base64 = base64Encode(utf8.encode(str));
    return base64.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
  }

  static String decode(String str) {
    String base64 = str.replaceAll('-', '+').replaceAll('_', '/');

    // Add padding if needed
    switch (base64.length % 4) {
      case 2:
        base64 += '==';
        break;
      case 3:
        base64 += '=';
        break;
    }

    return utf8.decode(base64Decode(base64));
  }
}

class FinderHelper {
  static SerializableFinder deserializeBase64(String base64Str) {
    try {
      // Decode base64 to JSON string
      final jsonStr = Base64URL.decode(base64Str);
      if (kDebugMode) {
        print('decoded string: $jsonStr');
      }

      // Parse JSON
      final dynamic finderData = json.decode(jsonStr);

      if (finderData is! Map<String, dynamic>) {
        throw Exception('finder is not valid');
      }

      if (!finderData.containsKey('finderType')) {
        throw Exception('Invalid finder format: missing finderType');
      }

      final String finderType = finderData['finderType'] as String;

      switch (finderType) {
        case 'ByText':
          return ByText(finderData['text'] as String);

        case 'ByType':
          return ByType(finderData['type'] as String);

        case 'ByValueKey':
          final keyType = finderData['keyValueType'] as String?;
          final keyValue = finderData['keyValueString'] as String;

          if (keyType == 'int') {
            return ByValueKey(int.parse(keyValue));
          }
          return ByValueKey(keyValue);

        case 'Ancestor':
          // Parse of and matching which are JSON strings
          final ofJson = json.decode(finderData['of'] as String);
          final matchingJson = json.decode(finderData['matching'] as String);

          return Ancestor(
            of: deserializeBase64(Base64URL.encode(json.encode(ofJson))),
            matching:
                deserializeBase64(Base64URL.encode(json.encode(matchingJson))),
            matchRoot: finderData['matchRoot'] == 'true',
            firstMatchOnly: finderData['firstMatchOnly'] == 'true',
          );

        case 'Descendant':
          final ofJson = json.decode(finderData['of'] as String);
          final matchingJson = json.decode(finderData['matching'] as String);

          return Descendant(
            of: deserializeBase64(Base64URL.encode(json.encode(ofJson))),
            matching:
                deserializeBase64(Base64URL.encode(json.encode(matchingJson))),
            matchRoot: finderData['matchRoot'] == 'true',
            firstMatchOnly: finderData['firstMatchOnly'] == 'true',
          );

        default:
          throw Exception('Unsupported finder type: $finderType');
      }
    } catch (e) {
      throw Exception('Error deserializing finder: $e');
    }
  }
}

class GetTextCommandExtension extends CommandExtension {
  String getTextFromWidget(Text widget) {
    // If direct text data is available, return it
    if (widget.data != null) {
      return widget.data!;
    }
    // Otherwise get text from textSpan
    if (widget.textSpan != null) {
      return getTextFromTextSpan(widget.textSpan!);
    }
    return 'TEXT_NOT_FOUND';
  }

  String getTextFromTextSpan(InlineSpan span) {
    if (span is TextSpan) {
      final List<String> textParts = <String>[];

      // Add current text if not null
      if (span.text != null) {
        textParts.add(span.text!);
      }

      // Add children's text recursively
      if (span.children != null) {
        for (final InlineSpan child in span.children!) {
          textParts.add(getTextFromTextSpan(child));
        }
      }

      return textParts.join('');
    }
    return 'WIDGET_IS_NOT_TEXT_SPAN';
  }

  @override
  Future<Result> call(
      Command command,
      WidgetController prober,
      CreateFinderFactory finderFactory,
      CommandHandlerFactory handlerFactory) async {
    final GetTextCommand dragCommand = command as GetTextCommand;

    // Create finder for Text widget
    final type = dragCommand.base64Element;
    // decodeBase64 to json
    SerializableFinder serializableFinder =
        FinderHelper.deserializeBase64(type);

    final Finder finder = finderFactory.createFinder(serializableFinder);

    // Get the widget element
    final Element element = prober.element(finder);

    // Get text data from Text widget
    String textData = '';

    if (element.widget is Text) {
      textData = getTextFromWidget(element.widget as Text);
    } else {
      textData = 'Found element is not a Text widget';
    }

    return GetTextResult(true, data: {'text': textData});
  }

  @override
  String get commandKind => 'getTextWithCommandExtension';

  @override
  Command deserialize(
      Map<String, String> params,
      DeserializeFinderFactory finderFactory,
      DeserializeCommandFactory commandFactory) {
    if (kDebugMode) {
      print('Available keys: ${params.keys.toList()}');
      print('Params content: $params');
    }
    return GetTextCommand.deserialize(params);
  }
}

class GetTextCommand extends Command {
  final String base64Element;

  GetTextCommand(this.base64Element);

  @override
  String get kind => 'getTextWithCommandExtension';

  GetTextCommand.deserialize(Map<String, String> params)
      : base64Element = params['findBy']!;
}

class GetTextResult extends Result {
  final bool success;
  final Map<String, dynamic>? data;

  const GetTextResult(this.success, {this.data});

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      if (data != null) ...data!,
    };
  }
}
