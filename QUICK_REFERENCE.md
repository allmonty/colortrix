# ColorTrix Quick Reference

## Quick Start
1. **Upload Image** → Select from gallery
2. **Edit Matrix** → Enter values or choose preset
3. **Preview** → Check color transformations
4. **Process** → Apply matrix to image
5. **Save** → Export processed image

## Matrix Layout
```
┌───────────┬───────────┬───────────┐
│   M00     │   M01     │   M02     │
│ Red from  │ Red from  │ Red from  │
│   Red     │  Green    │   Blue    │
├───────────┼───────────┼───────────┤
│   M10     │   M11     │   M12     │
│Green from │Green from │Green from │
│   Red     │  Green    │   Blue    │
├───────────┼───────────┼───────────┤
│   M20     │   M21     │   M22     │
│Blue from  │Blue from  │Blue from  │
│   Red     │  Green    │   Blue    │
└───────────┴───────────┴───────────┘
```

## Preset Matrices

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

### Sepia (Vintage)
```
0.393  0.769  0.189
0.349  0.686  0.168
0.272  0.534  0.131
```

### Invert (Negative)
```
-1.0   0.0   0.0
 0.0  -1.0   0.0
 0.0   0.0  -1.0
```

### Swap Red/Blue
```
0.0  0.0  1.0
0.0  1.0  0.0
1.0  0.0  0.0
```

## Common Effects

### Boost Red Channel
```
1.5  0.0  0.0
0.0  1.0  0.0
0.0  0.0  1.0
```

### Reduce Blue
```
1.0  0.0  0.0
0.0  1.0  0.0
0.0  0.0  0.5
```

### Warm Filter
```
1.1  0.0  0.0
0.05 0.95 0.0
0.0  0.05 0.95
```

### Cool Filter
```
0.95 0.0  0.05
0.0  0.95 0.05
0.0  0.0  1.1
```

### Remove Color Channel
```
0.0  0.0  0.0   ← Remove Red
0.0  1.0  0.0
0.0  0.0  1.0
```

## Matrix Value Guide

| Value | Effect |
|-------|--------|
| 0.0 | Removes that component |
| 0.5 | Halves the component |
| 1.0 | Keeps original value |
| 1.5 | Amplifies by 50% |
| -1.0 | Inverts component |

## Tips

✅ **DO:**
- Start with presets
- Use color preview before processing
- Save before trying new matrices
- Experiment with small changes (±0.1)

❌ **DON'T:**
- Use extremely large values (>2.0)
- Process without previewing
- Forget to save your work

## Keyboard Shortcuts
(When editing matrix values)
- `Tab` - Move to next field
- `Shift+Tab` - Move to previous field
- `Enter` - Confirm value

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Washed out colors | Reduce matrix values |
| Too bright/dark | Adjust diagonal values |
| Processing slow | Normal for large images |
| Can't find saved image | Check dialog for path |

## Formula

For each pixel:
```
R' = M[0][0]×R + M[0][1]×G + M[0][2]×B
G' = M[1][0]×R + M[1][1]×G + M[1][2]×B
B' = M[2][0]×R + M[2][1]×G + M[2][2]×B
```

All values clamped to [0.0, 1.0] range.

## Need Help?
- See USER_GUIDE.md for detailed instructions
- See DEVELOPMENT.md for technical details
- See ARCHITECTURE.md for system design

---
**ColorTrix** - Transform colors with matrix magic! ✨
