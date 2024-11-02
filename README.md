### Command Extension - flutter_driver

Example JSON-RPC Request
Here’s an example of how your request to the dragAndDrop command might look:

```json
{
  "jsonrpc": "2.0",
  "method": "dragAndDrop",
  "params": {
    "startX": 205,
    "startY": 116,
    "endX": 0,
    "endY": 172,
    "duration": 15000
  },
  "id": "c6a5207b-5960-4e22-952c-ec83a3caa952"
}
```

JSON-RPC Response Structure

```json
{
  "jsonrpc": "2.0",
  "result": {
    "success": true
  },
  "id": "c6a5207b-5960-4e22-952c-ec83a3caa952"
}
```


#### Install Dependencies:

```dart
flutter clean
flutter pub get
```

#### Build command

```agsl
flutter build apk --debug
```
