### Command Extension - flutter_driver

Example JSON-RPC Request
Here’s an example of how your request to the dragAndDrop command might look:

```json
{
  "jsonrpc": "2.0",
  "method": "dragAndDrop",
  "params": {
    "startX": 100,
    "startY": 200,
    "endX": 300,
    "endY": 400,
    "duration": 15000
  },
  "id": 1
}
```

JSON-RPC Response Structure

```json
{
  "jsonrpc": "2.0",
  "result": {
    "success": true
  },
  "id": 1
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
