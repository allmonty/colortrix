# ColorTrix - Matrix Color Editor

A Flutter application to edit image colors using a 3x3 matrix transformation.

## Features

- **Image Upload**: Click the button to upload an image from your gallery
- **Image Display**: The uploaded image is shown in the app after loading
- **3x3 Matrix Editor**: Fill a 3x3 matrix with numbers to define color transformations
- **Color Preview**: See real-time examples of what the matrix does to colors
- **Matrix Presets**: Quick access to common transformations (Identity, Grayscale, Sepia, Invert, Swap R/B)
- **Image Processing**: Apply the matrix transformation to every pixel of the image
- **Save Results**: Save the processed image to your device

## How It Works

The app applies a linear transformation to each pixel's RGB values using a 3x3 matrix:

```
[R']   [M00 M01 M02]   [R]
[G'] = [M10 M11 M12] × [G]
[B']   [M20 M21 M22]   [B]
```

Where:
- (R, G, B) are the original pixel color values (0-1)
- (R', G', B') are the transformed color values (0-1)
- M is the 3x3 transformation matrix

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- A device or emulator for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/allmonty/colortrix.git
   cd colortrix
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. **Upload an Image**: Tap the "Upload Image" button to select an image from your gallery
2. **Adjust the Matrix**: Enter values in the 3x3 matrix or select a preset transformation
3. **Preview Colors**: Observe how the matrix affects various colors in the preview section
4. **Process**: Tap "Process Image" to apply the matrix to your image
5. **Save**: After processing, tap "Save Processed Image" to save the result

## Example Transformations

### Identity (No Change)
```
1.0  0.0  0.0
0.0  1.0  0.0
0.0  0.0  1.0
```

### Grayscale
```
0.299  0.587  0.114
0.299  0.587  0.114
0.299  0.587  0.114
```

### Sepia
```
0.393  0.769  0.189
0.349  0.686  0.168
0.272  0.534  0.131
```

### Invert Colors
```
-1.0   0.0   0.0
 0.0  -1.0   0.0
 0.0   0.0  -1.0
```

### Swap Red and Blue
```
0.0  0.0  1.0
0.0  1.0  0.0
1.0  0.0  0.0
```

## License

This project is open source and available under the MIT License.
