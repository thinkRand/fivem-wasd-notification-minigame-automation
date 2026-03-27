# FiveM WASD Notification Minigame Automation

An AutoHotkey automation script for FiveM notification-based sequence minigames (SmokeCrack, Chopping, Lockpicking, etc.). Uses image recognition to detect letter sequences in real-time and executes simultaneous key presses for optimal speed.

## Features

- **Image Recognition**: Detects notification popups and individual letters using pixel/image search
- **Sequential Detection**: Algorithm finds letters in order by searching, offsetting by width, and continuing from the last position
- **Simultaneous Input**: Uses `SendInput` to press all detected keys at once (faster than sequential pressing)
- **Motion-Optimized**: Designed to work while images/letters are moving on screen
- **Non-Intrusive**: Pure pixel detection, no memory reading or injection

## Supported Minigames

This script is designed for FiveM minigames that display letter sequences in notification-style popups:

| Minigame | Description | Key Set |
|----------|-------------|---------|
| **SmokeCrack** | WiFi hacking - enter letters before timer expires | Q, W, E, R, A, S, D |
| **Chopping** | Car signal amplification sequence | Q, W, E, R, A, S, D |
| **Path** | WASD navigation through grid | W, A, S, D, Arrows |
| **Notification-based** | Any popup with letter sequences | Configurable |

## How It Works

### Detection Algorithm

The script uses an **adaptive sequential search** algorithm:

1. **Find First Letter**: Searches screen for the first letter image/notification
2. **Calculate Offset**: Determines letter width and adds offset to search position
3. **Continue Search**: Discards the found region and searches from the new position onward
4. **Build Sequence**: Repeats until all letters in the sequence are identified
5. **Simultaneous Press**: Sends all keys at once using `SendInput` for instant execution
   
## Installation

### Prerequisites

- [AutoHotkey v1.1+](https://www.autohotkey.com/)
- FiveM running in windowed/borderless mode
- Letter images for recognition (place in `/images` folder)

### Setup

1. Download and install AutoHotkey
2. Clone this repository
3. Capture reference images of each letter (W, A, S, D, Q, E, R) from your specific minigame
4. Place images in the script directory
5. Run `wasd_minigame.ahk`

### Image Preparation

For reliable detection, capture clean images of:
- Individual letters (W, A, S, D, Q, E, R)
- The notification popup background (for region detection)
- Each letter at the exact size it appears in-game

**Tip**: Use the same resolution and graphics settings when capturing images.

## Configuration

### Search Strategy

The script supports two detection modes (configurable in source):

| Mode | Description | Use Case |
|------|-------------|----------|
| **Option 1** | Screenshot notification, then OCR/recognize letters | Static/high-res letters |
| **Option 2** | Find notification, then search for letters in order | Moving/changing letters |

Current implementation uses **Option 2** for better performance with moving elements.

## Usage

### Hotkeys

| Key | Function |
|-----|----------|
| `F1` | Start detection and automation |
| `F2` | Pause/Resume script |
| `F3` | Reload script (if images change) |
| `F4` | Exit script |

### Workflow

1. Stand near the hacking location (car, WiFi spot, etc.)
2. Start the minigame normally
3. When the notification/letters appear, press `F1`
4. The script will:
   - Detect the notification region
   - Find each letter in sequence
   - Press all keys simultaneously
5. Minigame completes instantly

### Performance Considerations

- **Search Direction**: Left-to-right (natural reading order)
- **Offset Calculation**: Prevents detecting the same letter twice
- **Region Discarding**: Eliminates false positives from previous matches
- **SendInput vs Send**: `SendInput` is faster and more reliable for gaming 

### Motion Handling

The script is tested to work while:
- Letters are sliding in (animation)
- Notification is fading in/out
- Screen has slight motion blur

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Letters not detected | Check image resolution matches game; re-capture at current settings |
| Wrong order detected | Increase `letterWidth` offset value in script |
| Only detects first letter | Verify search region covers full notification width |
| Detection too slow | Reduce image size or use simpler color-based detection |
| Keys not registering | Ensure FiveM is focused; try `SendPlay` instead of `SendInput` |
| Works in test, fails in game | Game may use different rendering; try windowed mode |

## Advanced Configuration

### Tuning Detection

Edit these variables in the script header:

```autohotkey
letterWidth := 32          ; Width of each letter in pixels
letterSpacing := 8         ; Space between letters
searchVariation := 25        ; Color variation tolerance (0-255)
notificationColor := 0xFFFFFF  ; Background color of notification
```

### Alternative: Pixel-Based Detection

If image search is too slow, switch to pixel detection:

```autohotkey
; Instead of ImageSearch, use PixelSearch for specific letter colors
PixelSearch, x, y, x1, y1, x2, y2, letterColor, variation
```

## Limitations

- **Resolution Dependent**: Images must match current screen resolution
- **Color Sensitive**: Graphics settings (brightness, contrast) affect detection
- **Single Monitor**: Designed for single-screen setups
- **No-Pixel Servers**: Will not work on servers with pure skill-based anticheat
- 
---

**Disclaimer**: The author is not responsible for any account bans, penalties, or consequences resulting from the use of this script. Always respect server rules and play fair.

## References

This script is compatible with minigames similar to those found on NoPixel 4.0 and other FiveM roleplay servers .
