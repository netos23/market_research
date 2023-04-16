import 'dart:typed_data';

import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    Key? key,
    required this.bytes,
  }) : super(key: key);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск товаров'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              '/result',
              arguments: bytes,
            ),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Center(
        child: Image.memory(bytes),
      ),
    );
  }
}
