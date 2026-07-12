# AI Eyes

AI Eyes is a Flutter camera assistant designed for blind and low-vision users. A user can point the phone camera at the world and hear concise spoken feedback about scenes, readable text, medicine labels, Indian currency, and nearby obstacles.

## Core Features

- Spoken scene descriptions with `flutter_tts`
- Live camera mode that refreshes every 3 seconds
- Medicine label reader with conservative prompt engineering
- Indian currency note detector
- Obstacle detection mode for hazards and navigation
- Text reader mode for signs, menus, and printed text
- Voice commands with `speech_to_text`
- Multilingual output for English, Hindi, Marathi, Tamil, and Telugu

## Voice Commands

Say short commands such as:

- `capture`
- `start live mode`
- `stop live mode`
- `scene mode`
- `text mode`
- `medicine mode`
- `currency mode`
- `obstacle mode`
- `repeat`
- `switch language to Hindi`

## Setup

1. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

2. Create or update `secrets.json` and provide your API keys:

   ```json
   {
     "GEMINI_API_KEY": "your-gemini-api-key",
     "GOOGLE_TRANSLATE_API_KEY": "your-google-translate-api-key"
   }
   ```

3. Run the app with the keys:

   ```bash
   flutter run --dart-define-from-file=secrets.json
   ```

## Notes

- Gemini powers image understanding.
- Google Translate is used for non-English spoken output and multilingual voice-command parsing.
- If the Translate API key is missing, the app falls back to English output gracefully.
