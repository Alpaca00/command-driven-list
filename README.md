### Command Extension - flutter_driver

Example JSON-RPC Request

```json
{
  "jsonrpc": "2.0",
  "method": "dragAndDropWithCommandExtension",
  "params": {
    "startX": 205,
    "startY": 116,
    "endX": 0,
    "endY": 172,
    "duration": 15000
  },
  "id": "1"
}
```

JSON-RPC Response Structure

```json
{
  "jsonrpc": "2.0",
  "result": {
    "success": true
  },
  "id": "1"
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
