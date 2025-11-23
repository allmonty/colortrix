# User Guide - ColorTrix

## Introduction

ColorTrix is a powerful image color editing application that uses mathematical matrix transformations to modify the colors of your images. Unlike traditional photo editors, ColorTrix gives you direct control over how colors are transformed using a 3x3 matrix.

## Getting Started

### Step 1: Upload an Image

1. Launch the ColorTrix app
2. Tap the **"Upload Image"** button at the top of the screen
3. Select an image from your device's photo gallery
4. The image will be displayed in the app

### Step 2: Understanding the Matrix

After uploading an image, you'll see a 3x3 matrix with numbers. This matrix controls how colors are transformed:

- **First row** (M00, M01, M02): Controls the **Red** output channel
- **Second row** (M10, M11, M12): Controls the **Green** output channel  
- **Third row** (M20, M21, M22): Controls the **Blue** output channel

Each cell in the matrix represents how much of each input color contributes to each output color:

```
[R'] = [M00 M01 M02] × [R]
[G']   [M10 M11 M12]   [G]
[B']   [M20 M21 M22]   [B]
```

### Step 3: Choose a Preset or Enter Custom Values

#### Using Presets

ColorTrix comes with several preset transformations:

- **Identity**: No change (original colors)
- **Grayscale**: Converts to black and white
- **Sepia**: Vintage warm tone effect
- **Invert**: Creates a color negative
- **Swap R/B**: Swaps red and blue channels

Simply tap any preset button to apply it.

#### Custom Values

You can enter your own values in each matrix cell:

1. Tap on any cell in the 3x3 matrix
2. Enter a number (can be negative or decimal)
3. The color preview will update automatically

**Tips for custom values:**
- Values are typically between -2.0 and 2.0
- Use 1.0 on the diagonal for the identity matrix
- Negative values create inverted effects
- Values above 1.0 amplify colors (may cause clipping)

### Step 4: Preview Color Changes

The **Color Preview** section shows 8 sample colors (red, green, blue, yellow, cyan, magenta, white, black) and how they will be transformed:

- **Top square**: Original color
- **Arrow**: Indicates transformation
- **Bottom square**: Transformed color

This preview updates in real-time as you change matrix values, helping you understand what the matrix will do to your image before processing.

### Step 5: Process the Image

1. Once you're satisfied with the matrix values, tap the **"Process Image"** button
2. The app will apply the matrix transformation to every pixel
3. For large images, this may take a few seconds
4. A loading indicator shows the processing is in progress

### Step 6: View and Save the Result

1. After processing, the transformed image appears below the "Process Image" button
2. Compare the original and processed images
3. If you're happy with the result, tap **"Save Processed Image"**
4. A dialog will show you where the image was saved

## Common Use Cases

### Creating Black and White Photos

Use the **Grayscale** preset for standard grayscale conversion, or create your own:

```
0.299  0.587  0.114
0.299  0.587  0.114
0.299  0.587  0.114
```

These coefficients represent how humans perceive brightness (green appears brighter than red, which appears brighter than blue).

### Boosting or Reducing Color Channels

To increase red and decrease blue:
```
1.5  0.0  0.0
0.0  1.0  0.0
0.0  0.0  0.5
```

### Creating a Color Negative

Use the **Invert** preset or enter:
```
-1.0   0.0   0.0
 0.0  -1.0   0.0
 0.0   0.0  -1.0
```

Note: This creates a true mathematical inversion. Colors will be clamped to valid range (0-1).

### Channel Swapping

Swap any two color channels. For example, to swap red and blue, use **Swap R/B** preset:
```
0.0  0.0  1.0
0.0  1.0  0.0
1.0  0.0  0.0
```

### Custom Color Grading

Experiment with decimal values to create unique color grading effects:
```
1.1  0.1  0.0
0.0  0.9  0.1
0.0  0.1  1.0
```

## Tips and Tricks

1. **Start with presets**: Use presets as starting points and then tweak individual values
2. **Use the color preview**: Always check the color preview before processing to understand the effect
3. **Save your work**: Process and save before trying different matrices
4. **Undo is upload**: To start over, upload the image again
5. **Experiment**: Don't be afraid to try unusual values - the preview shows you the effect

## Understanding Matrix Values

### Diagonal Values (M00, M11, M22)
These control how much each color keeps its own channel:
- 1.0: Keep original amount
- > 1.0: Amplify that color
- < 1.0: Reduce that color
- 0.0: Remove that color completely

### Off-Diagonal Values
These control color mixing:
- M01 and M02 in row 0: How much Green and Blue contribute to Red output
- M10 and M12 in row 1: How much Red and Blue contribute to Green output
- M20 and M21 in row 2: How much Red and Green contribute to Blue output

### Example: Making Reds Darker

To reduce red intensity by 30%:
```
0.7  0.0  0.0
0.0  1.0  0.0
0.0  0.0  1.0
```

## Troubleshooting

**Problem**: Colors look washed out or too bright
- **Solution**: Reduce values in the matrix (try 0.8 instead of 1.0)

**Problem**: Image has harsh clipping (pure white or black areas)
- **Solution**: Values are too extreme. Use values closer to -1.0 to 1.0

**Problem**: Processing takes too long
- **Solution**: Very large images (>4000x4000) can take time. Consider resizing first

**Problem**: Saved image location unknown
- **Solution**: The save dialog shows the full path. Check your device's document or download folder

**Problem**: Can't see the preview well
- **Solution**: Try presets to see dramatic changes, or use more extreme values temporarily

## Advanced Usage

### Creating Specific Effects

**Warm Filter** (add warmth):
```
1.1  0.0  0.0
0.05 0.95 0.0
0.0  0.05 0.95
```

**Cool Filter** (add coolness):
```
0.95 0.0  0.05
0.0  0.95 0.05
0.0  0.0  1.1
```

**Increase Contrast** (not perfect contrast, but creates an effect):
```
1.2  0.0  0.0
0.0  1.2  0.0
0.0  0.0  1.2
```

**Vintage Look** (combine sepia with slight fade):
```
0.35  0.68  0.17
0.31  0.61  0.15
0.24  0.47  0.12
```

## Frequently Asked Questions

**Q: What image formats are supported?**
A: JPEG, PNG, and most common image formats supported by your device.

**Q: Does this reduce image quality?**
A: The app saves processed images as PNG (lossless), so no quality is lost in the transformation itself.

**Q: Can I process the same image multiple times?**
A: Yes! Save the processed image, then upload it again and apply a new matrix.

**Q: What's the maximum image size?**
A: Limited by your device's memory. Very large images (>10 megapixels) may process slowly.

**Q: Can I save my custom matrix?**
A: Currently, you'll need to note down the values. Future versions may add saved presets.

**Q: Why are my colors clamped?**
A: Color values must be between 0 and 255 (or 0.0 and 1.0 normalized). Extreme matrix values may push colors outside this range, so they're automatically clamped to valid values.

## Getting Help

If you encounter issues or have suggestions:
1. Check this user guide
2. Review the DEVELOPMENT.md for technical details
3. File an issue on the project repository

Enjoy creating unique color transformations with ColorTrix!
