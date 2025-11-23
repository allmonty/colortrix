# Development Guide

## Project Structure

```
colortrix/
├── lib/
│   └── main.dart                 # Main application code
├── android/                       # Android platform files
│   ├── app/
│   │   ├── build.gradle          # App-level Gradle configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/com/example/colortrix/
│   │           └── MainActivity.kt
│   ├── build.gradle              # Project-level Gradle configuration
│   ├── settings.gradle
│   └── gradle.properties
├── ios/                          # iOS platform files
│   └── Runner/
│       ├── AppDelegate.swift
│       └── Info.plist
├── web/                          # Web platform files
│   ├── index.html
│   └── manifest.json
├── test/
│   └── widget_test.dart          # Widget tests
├── pubspec.yaml                  # Project dependencies
├── analysis_options.yaml         # Dart analyzer configuration
└── README.md

## Implementation Details

### Main Components

#### 1. MyApp (StatelessWidget)
- Root widget of the application
- Configures Material Design theme
- Sets up ColorTrix as the home page

#### 2. ColorTrixPage (StatefulWidget)
The main page with all functionality:

**State Variables:**
- `_imageFile`: The uploaded image file
- `_originalImage`: Decoded image for processing
- `_processedImage`: Result after matrix transformation
- `_matrixControllers`: 3x3 grid of TextEditingControllers for matrix input
- `_isProcessing`: Flag to show processing status

**Key Methods:**

##### `_pickImage()`
- Uses ImagePicker to select an image from gallery
- Loads and decodes the image
- Resets processed image state

##### `_getMatrix()`
- Extracts and parses numeric values from matrix input fields
- Returns a 3x3 List<List<double>> matrix
- Defaults to 0.0 for invalid inputs

##### `_processImage()`
- Applies the color transformation matrix to every pixel
- For each pixel (R, G, B):
  - Normalizes values to 0-1 range
  - Applies matrix multiplication: [R', G', B'] = M × [R, G, B]
  - Clamps results to 0-1 range
  - Converts back to 0-255 range
- Updates UI with processed image

##### `_saveImage()`
- Encodes processed image to PNG format
- Saves to temporary directory with timestamp
- Shows dialog with saved file path

##### `_setMatrixPreset(preset)`
- Applies predefined transformation matrices
- Available presets:
  - **identity**: No change (diagonal matrix)
  - **grayscale**: Standard luminance-based grayscale
  - **sepia**: Warm vintage tone
  - **invert**: Color negative
  - **swap_rb**: Swaps red and blue channels

##### `_applyMatrixToColor(Color)`
- Preview function for single color transformation
- Used in real-time color preview widget

##### `_buildColorPreview()`
- Shows 8 test colors (red, green, blue, yellow, cyan, magenta, white, black)
- Displays before/after transformation for each color
- Updates in real-time as matrix values change

##### `_buildMatrixInput()`
- Creates 3x3 grid of text fields for matrix values
- Shows preset buttons for quick transformations
- Validates numeric input

### Matrix Mathematics

The color transformation uses matrix multiplication:

```
┌   ┐   ┌               ┐   ┌   ┐
│ R'│   │ M00  M01  M02 │   │ R │
│ G'│ = │ M10  M11  M12 │ × │ G │
│ B'│   │ M20  M21  M22 │   │ B │
└   ┘   └               ┘   └   ┘
```

Where:
- Each row of the matrix determines how the output color channel is calculated
- Row 0 (M00, M01, M02) determines the new Red value
- Row 1 (M10, M11, M12) determines the new Green value
- Row 2 (M20, M21, M22) determines the new Blue value

Example - Grayscale conversion:
```
R' = 0.299*R + 0.587*G + 0.114*B  (perceptual luminance)
G' = 0.299*R + 0.587*G + 0.114*B  (same for all channels)
B' = 0.299*R + 0.587*G + 0.114*B
```

### Dependencies

**Runtime Dependencies:**
- `flutter`: Flutter SDK
- `image_picker: ^1.0.4`: Image selection from gallery
- `image: ^4.1.3`: Image encoding/decoding and pixel manipulation
- `cupertino_icons: ^1.0.2`: iOS-style icons

**Development Dependencies:**
- `flutter_test`: Testing framework
- `flutter_lints: ^3.0.0`: Dart code analysis rules

### Platform-Specific Configurations

#### Android
- **Minimum SDK**: 21 (Android 5.0 Lollipop)
- **Permissions**: 
  - READ_EXTERNAL_STORAGE
  - WRITE_EXTERNAL_STORAGE
  - INTERNET

#### iOS
- **Required Permissions**:
  - NSPhotoLibraryUsageDescription: For image selection
  - NSCameraUsageDescription: For camera access

#### Web
- HTML5 file picker support
- Canvas API for image rendering

## Building the App

### Prerequisites
1. Install Flutter SDK (>=3.0.0)
2. Install platform-specific tools:
   - Android: Android Studio, Android SDK
   - iOS: Xcode (macOS only)
   - Web: Chrome browser

### Commands

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build for production
flutter build apk         # Android
flutter build ios         # iOS
flutter build web         # Web

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Testing

### Widget Tests
Location: `test/widget_test.dart`

Tests verify:
- App initialization
- Upload button presence
- Widget tree structure

To add more tests:
```dart
testWidgets('Description', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  // Add expectations
  expect(find.text('...'), findsOneWidget);
});
```

## Performance Considerations

1. **Image Processing**:
   - Processing happens synchronously on the UI thread
   - For very large images, consider using `compute()` for background processing
   
2. **Memory Usage**:
   - Both original and processed images are kept in memory
   - Consider releasing the original after processing for large images

3. **Matrix Validation**:
   - Input values are parsed on every change
   - Results are clamped to valid color range (0-1)

## Future Enhancements

Potential improvements:
1. Add more matrix presets (brightness, contrast, saturation)
2. Implement undo/redo functionality
3. Add image comparison slider
4. Support for multiple image formats
5. Export custom matrices as presets
6. Real-time preview during processing
7. Batch processing of multiple images
8. GPU-accelerated processing for large images
9. Color picker for before/after comparison
10. Histogram display

## Troubleshooting

**Issue**: Image not loading
- Check platform permissions are granted
- Verify image format is supported (JPEG, PNG, etc.)

**Issue**: Processing is slow
- Large images take more time to process
- Consider resizing image before processing
- Implement progress indicator for better UX

**Issue**: Colors look wrong
- Verify matrix values are correct
- Check if values should be normalized (0-1) or not
- Try the "Identity" preset to reset

**Issue**: App crashes on processing
- Check for very large images (>4096x4096)
- Verify sufficient memory is available
- Add try-catch blocks for error handling
