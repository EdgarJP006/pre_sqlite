import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

TextSpan parseText(BuildContext context, String text) {
  // Lista para almacenar números de referencia extraídos en el orden en que aparecen
  List<String> referenceNumbers = [];

  // Reemplaza las referencias con espacios vacíos y almacena los números en la lista
  final cleanedText = text.replaceAllMapped(RegExp(r'\[(\d+)†\]'), (match) {
    referenceNumbers.add(match.group(1)!); // Conserva el número de referencia
    return ''; // Reemplaza con vacío en el texto
  });

  // Parsear el texto limpio
  final document = xml.XmlDocument.parse('<root>$cleanedText</root>');
  List<TextSpan> spans =
      _parseNode(context, document.rootElement, referenceNumbers);
  return TextSpan(children: spans, style: TextStyle(color: Colors.black));
}

List<TextSpan> _parseNode(
    BuildContext context, xml.XmlNode node, List<String> referenceNumbers) {
  List<TextSpan> spans = [];
  int referenceIndex = 0; // Índice para rastrear las referencias en orden

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
          // Manejo opcional para salto de página
          break;
        case 'f':
          // Asigna el siguiente número de referencia de la lista
          final refText = referenceNumbers[referenceIndex];
          referenceIndex++; // Avanza al siguiente número para la próxima referencia

          spans.add(
            TextSpan(
              text: refText + ' ', // Muestra el número de referencia
              style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Referencia"),
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
