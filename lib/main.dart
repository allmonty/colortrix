import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorTrix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ColorTrixPage(title: 'ColorTrix - Matrix Color Editor'),
    );
  }
}

class ColorTrixPage extends StatefulWidget {
  const ColorTrixPage({super.key, required this.title});

  final String title;

  @override
  State<ColorTrixPage> createState() => _ColorTrixPageState();
}

class _ColorTrixPageState extends State<ColorTrixPage> {
  Uint8List? _imageBytes;
  img.Image? _originalImage;
  img.Image? _processedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  // 3x3 matrix for color transformation
  // Default is identity matrix
  final List<List<TextEditingController>> _matrixControllers = List.generate(
    3,
    (i) => List.generate(
      3,
      (j) => TextEditingController(text: i == j ? '1.0' : '0.0'),
    ),
  );

  @override
  void dispose() {
    for (var row in _matrixControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Load the image bytes
      final bytes = await image.readAsBytes();
      
      setState(() {
        _imageBytes = bytes;
        _processedImage = null;
      });

      // Decode the image
      _originalImage = img.decodeImage(bytes);
    }
  }

  List<List<double>> _getMatrix() {
    return _matrixControllers
        .map((row) => row.map((controller) {
              final value = double.tryParse(controller.text);
              return value ?? 0.0;
            }).toList())
        .toList();
  }

  static img.Image _applyMatrixTransformation(
      Map<String, dynamic> params) {
    final img.Image original = params['image'] as img.Image;
    final List<List<double>> matrix =
        params['matrix'] as List<List<double>>;

    final processed = img.Image.from(original);

    for (int y = 0; y < processed.height; y++) {
      for (int x = 0; x < processed.width; x++) {
        final pixel = processed.getPixel(x, y);

        // Extract RGB components (0-255)
        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;

        // Apply matrix transformation
        final newR = (matrix[0][0] * r + matrix[0][1] * g + matrix[0][2] * b)
            .clamp(0.0, 1.0);
        final newG = (matrix[1][0] * r + matrix[1][1] * g + matrix[1][2] * b)
            .clamp(0.0, 1.0);
        final newB = (matrix[2][0] * r + matrix[2][1] * g + matrix[2][2] * b)
            .clamp(0.0, 1.0);

        // Set the new pixel value
        processed.setPixelRgba(
          x,
          y,
          (newR * 255).round(),
          (newG * 255).round(),
          (newB * 255).round(),
          pixel.a.toInt(),
        );
      }
    }

    return processed;
  }

  Future<void> _processImage() async {
    if (_originalImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    // Get the matrix values
    final matrix = _getMatrix();

    // Process the image in a separate isolate for better performance
    final processed = await compute(_applyMatrixTransformation, {
      'image': _originalImage!,
      'matrix': matrix,
    });

    setState(() {
      _processedImage = processed;
      _isProcessing = false;
    });
  }

  Future<void> _saveImage() async {
    if (_processedImage == null) return;

    try {
      // Encode the image to PNG
      final png = img.encodePng(_processedImage!);

      if (kIsWeb) {
        // For web, trigger download using browser API
        // Note: This requires additional web-specific implementation
        // For now, we'll just show a message
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Download Image'),
              content: const Text(
                  'On web, please right-click the processed image and select "Save image as..."'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // For mobile/desktop platforms
        Directory directory;
        if (Platform.isAndroid) {
          // For Android, try to get the external storage directory
          directory = await getApplicationDocumentsDirectory();
        } else if (Platform.isIOS) {
          // For iOS, use the application documents directory
          directory = await getApplicationDocumentsDirectory();
        } else {
          // For other platforms, use downloads directory if available
          directory = await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory();
        }

        // Create a file with timestamp
        final fileName =
            'colortrix_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(png);

        // Show a dialog with the saved path
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Image Saved'),
              content: Text('Image saved to:\n${file.path}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Show error dialog if saving fails
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save image: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _setMatrixPreset(String preset) {
    final presets = {
      'identity': [
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 0.0, 1.0],
      ],
      'grayscale': [
        [0.299, 0.587, 0.114],
        [0.299, 0.587, 0.114],
        [0.299, 0.587, 0.114],
      ],
      'sepia': [
        [0.393, 0.769, 0.189],
        [0.349, 0.686, 0.168],
        [0.272, 0.534, 0.131],
      ],
      'invert': [
        [-1.0, 0.0, 0.0],
        [0.0, -1.0, 0.0],
        [0.0, 0.0, -1.0],
      ],
      'swap_rb': [
        [0.0, 0.0, 1.0],
        [0.0, 1.0, 0.0],
        [1.0, 0.0, 0.0],
      ],
    };

    if (presets.containsKey(preset)) {
      setState(() {
        final matrix = presets[preset]!;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            _matrixControllers[i][j].text = matrix[i][j].toString();
          }
        }
      });
    }
  }

  Color _applyMatrixToColor(Color color) {
    final matrix = _getMatrix();
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    final newR = (matrix[0][0] * r + matrix[0][1] * g + matrix[0][2] * b)
        .clamp(0.0, 1.0);
    final newG = (matrix[1][0] * r + matrix[1][1] * g + matrix[1][2] * b)
        .clamp(0.0, 1.0);
    final newB = (matrix[2][0] * r + matrix[2][1] * g + matrix[2][2] * b)
        .clamp(0.0, 1.0);

    return Color.fromARGB(
      color.alpha,
      (newR * 255).round(),
      (newG * 255).round(),
      (newB * 255).round(),
    );
  }

  Widget _buildColorPreview() {
    final testColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.cyan,
      const Color(0xFFFF00FF), // Magenta
      Colors.white,
      Colors.black,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: testColors.map((color) {
                final transformedColor = _applyMatrixToColor(color);
                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.arrow_downward, size: 16),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: transformedColor,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3x3 Color Transformation Matrix',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: List.generate(3, (i) {
                return TableRow(
                  children: List.generate(3, (j) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: _matrixControllers[i][j],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: '[$i][$j]',
                            contentPadding: const EdgeInsets.all(8),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text('Presets:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _setMatrixPreset('identity'),
                  child: const Text('Identity'),
                ),
                ElevatedButton(
                  onPressed: () => _setMatrixPreset('grayscale'),
                  child: const Text('Grayscale'),
                ),
                ElevatedButton(
                  onPressed: () => _setMatrixPreset('sepia'),
                  child: const Text('Sepia'),
                ),
                ElevatedButton(
                  onPressed: () => _setMatrixPreset('invert'),
                  child: const Text('Invert'),
                ),
                ElevatedButton(
                  onPressed: () => _setMatrixPreset('swap_rb'),
                  child: const Text('Swap R/B'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              if (_imageBytes != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Original Image',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Image.memory(
                            _imageBytes!,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMatrixInput(),
                const SizedBox(height: 16),
                _buildColorPreview(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processImage,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.transform),
                  label: Text(_isProcessing ? 'Processing...' : 'Process Image'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_processedImage != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Processed Image',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Image.memory(
                            Uint8List.fromList(img.encodePng(_processedImage!)),
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _saveImage,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Processed Image'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
