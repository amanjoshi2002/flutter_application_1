# TruthCourt - Setup Instructions

This is a Flutter app that allows you to fact-check messages using AI-powered analysis with a floating hover ball overlay.

## Prerequisites

1. **Enable Developer Mode on Windows** (Required for Flutter plugins):
   - Press `Windows + I` to open Settings
   - Go to `Privacy & Security` > `For developers`
   - Turn on `Developer Mode`
   
   OR run this command in PowerShell:
   ```powershell
   start ms-settings:developers
   ```

2. **Flutter SDK** installed and configured
3. **Android device or emulator** (API level 23 or higher)

## Setup Steps

### 1. Install Dependencies

Run in your terminal:
```bash
flutter pub get
```

### 2. Android Permissions

The app requires the following permissions (already configured in AndroidManifest.xml):
- `SYSTEM_ALERT_WINDOW` - For displaying the hover ball overlay
- `INTERNET` - For API calls
- `FOREGROUND_SERVICE` - For keeping the overlay active
- `POST_NOTIFICATIONS` - For notifications

### 3. Build and Run

```bash
# For debug mode
flutter run

# For release mode
flutter build apk --release
```

## How to Use

1. **Launch the app** and tap "Show Hover Ball"
2. **Grant overlay permission** when prompted
3. The floating ball will appear on your screen
4. **Copy any text** you want to fact-check
5. **Tap the hover ball** - it will:
   - Read the text from your clipboard
   - Send it to the TruthCourt backend API
   - Show a loading indicator (analysis takes up to 2 minutes)
   - Display the results with verdict (SCAM or LEGITIMATE)

## Features

- ✅ Floating draggable hover ball overlay
- ✅ Works on top of any app
- ✅ AI-powered fact-checking with debate-style analysis
- ✅ Beautiful dark-themed result screen
- ✅ Shows verdict, summary, evidence, and debate arguments
- ✅ Handles long-running API requests (up to 2 minutes)

## API Endpoint

The app connects to:
- **URL**: `https://backend.truthcourt.online/analyze`
- **Method**: POST
- **Body**: `{"message": "your text here"}`

## Troubleshooting

### Issue: "Building with plugins requires symlink support"
**Solution**: Enable Developer Mode on Windows (see Prerequisites #1)

### Issue: Overlay not showing
**Solution**: 
1. Check if overlay permission is granted
2. Go to Settings > Apps > TruthCourt > Display over other apps
3. Enable the permission

### Issue: "No text found"
**Solution**: Make sure to copy text to clipboard before tapping the hover ball

### Issue: API timeout
**Solution**: The API can take up to 2 minutes. Be patient and don't tap multiple times.

## Architecture

```
lib/
├── main.dart                          # Main app entry point
├── overlay_entry.dart                 # Overlay widget entry point
├── models/
│   └── analysis_response.dart         # Data models for API response
├── services/
│   ├── api_service.dart              # API communication service
│   └── overlay_service.dart          # Overlay management service
└── screens/
    └── analysis_result_screen.dart   # Results display screen
```

## Notes

- The hover ball uses `flutter_overlay_window` package
- Minimum Android SDK: 23 (Android 6.0)
- The overlay works system-wide across all apps
- Analysis results are cached for quick access
