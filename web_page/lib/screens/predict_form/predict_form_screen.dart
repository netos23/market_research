import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class PredictFormScreen extends StatefulWidget {
  const PredictFormScreen({Key? key}) : super(key: key);

  @override
  State<PredictFormScreen> createState() => _PredictFormScreenState();
}

class _PredictFormScreenState extends State<PredictFormScreen> {
  final hasDrag = ValueNotifier(false);
  final controller = ValueNotifier<DropzoneViewController?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск по изображениям'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (kIsWeb)
            Positioned.fill(
              child: DropzoneView(
                operation: DragOperation.copy,
                onHover: () => hasDrag.value = true,
                onLeave: () => hasDrag.value = false,
                onCreated: (c) => controller.value = c,
                onDrop: _pickFile,
              ),
            ),
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: hasDrag,
              builder: (context, drag, _) {
                if (drag) {
                  return const ColoredBox(
                    color: Colors.lightGreenAccent,
                    child: Center(
                      child: Text(
                        'Бросьте фаил, что бы найти похожие',
                      ),
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Перетащите фаил или выбирите фаил',
                    ),
                    ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, c, _) {
                        if (c == null) {
                          return const SizedBox.shrink();
                        }

                        return ElevatedButton(
                          onPressed: () async {
                            final file = await c.pickFiles();
                            if (file.isNotEmpty) {
                              await _pickFile(file.first);
                            }
                          },
                          child: const Text(
                            'Выбрать фаил',
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(file) async {
    hasDrag.value = false;
    final type = await controller.value!.getFileMIME(file);

    if (!type.contains('image')) {
      _displayError();
    }

    final data = await controller.value!.getFileData(file);

    _openPreview(data);
  }

  void _openPreview(Uint8List data) {
    Navigator.of(context).pushNamed(
      '/preview',
      arguments: data,
    );
  }

  void _displayError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Неподдерживаемый тип данных'),
      ),
    );
  }
}
