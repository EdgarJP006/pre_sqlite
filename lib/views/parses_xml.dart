import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

// Función para convertir número a representación alfabética
String numberToAlphabetic(int number) {
  number--; // Ajustar para indexación de 0
  String result = '';
  while (number >= 0) {
    result = String.fromCharCode((number % 26) + 97) + result;
    number = (number ~/ 26) - 1;
  }
  return result;
}

int globalReferenceIndex = 0; // Índice global para la referencia

TextSpan parseText(BuildContext context, String text) {
  List<String> referenceNumbers = [];

  final cleanedText = text.replaceAllMapped(RegExp(r'\[(\d+)†\]'), (match) {
    referenceNumbers.add(match.group(1)!);
    return '';
  });

  final document = xml.XmlDocument.parse('<root>$cleanedText</root>');
  List<TextSpan> spans =
      _parseNode(context, document.rootElement, referenceNumbers);
  return TextSpan(children: spans, style: TextStyle(color: Colors.black));
}

List<TextSpan> _parseNode(
    BuildContext context, xml.XmlNode node, List<String> referenceNumbers) {
  List<TextSpan> spans = [];

  node.children.forEach((child) {
    if (child is xml.XmlText) {
      spans.add(TextSpan(text: child.value));
    } else if (child is xml.XmlElement) {
      TextStyle? style;
      switch (child.name.local) {
        case 'i':
          style = TextStyle(fontStyle: FontStyle.italic);
          break;
        case 'J':
          style = TextStyle(color: Colors.red);
          break;
        case 't':
          style = TextStyle(fontWeight: FontWeight.bold);
          break;
        case 'pb':
          break;
        case 'f':
          final refText = numberToAlphabetic(
              globalReferenceIndex + 1); // Convertir a alfabético
          globalReferenceIndex++; // Incremento global

          spans.add(
            TextSpan(
              text: '$refText†',
              style: const TextStyle(
                color: Color.fromARGB(255, 148, 148, 148),
                fontSize: 10, // Tamaño pequeño para simular superíndice
                // decoration: TextDecoration.overline,
                fontStyle: FontStyle.italic,
                height: 0.8, // Ajusta la altura
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Referencia"),
                        content: Text("Número de referencia: $refText"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cerrar"),
                          ),
                        ],
                      );
                    },
                  );
                },
            ),
          );
          break;
        default:
          style = null;
      }

      if (style != null) {
        spans.add(TextSpan(
          text: '',
          children: _parseNode(context, child, referenceNumbers),
          style: style,
        ));
      } else {
        spans.addAll(_parseNode(context, child, referenceNumbers));
      }
    }
  });

  return spans;
}
