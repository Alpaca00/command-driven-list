## command-driven-list

Project demonstrates how to use the `driver_extension` library to extend the Flutter Driver with custom commands or finders.

## Appium Flutter Driver with Command Extension

Install application from the [builds](builds) directory with all necessary dependencies or build the application from the source code.


Build the application from the source code:

Android:
```shell
flutter build apk --debug --target-platform android-arm64,android-arm,android-x64
```

iOS:
```shell
flutter build ipa --profile
```

2. Install the application on the device.
3. Follow the code to interact with the application using the [Appium Flutter Driver](https://github.com/appium/appium-flutter-driver?tab=readme-ov-file#simple-examples-in-nodejs) with the Command Extension.



## Run app with Observatory and explore the Command Extension directly

The Flutter Observatory provides insights into the app's VM and allows interaction with it. 

You need to start the application with the observatory port enabled to interact with the WebSocket server.

Run the following command to start your Flutter application with the observatory port (8888) enabled:

```shell
flutter run --observatory-port=8888
```

The app will start and the WebSocket server will be available on port 8888.

### Install wscat (WebSocket Client)

`wscat` is a simple WebSocket client that will allow us to send and receive messages to and from the Flutter VM over the WebSocket protocol.


Install `wscat` globally using npm:

```shell
npm install -g wscat
```

This will enable you to connect to the WebSocket server from the terminal.

#### Connect to the Flutter VM via WebSocket

Now that `wscat` is installed, you can use it to establish a WebSocket connection to the Flutter VM.

Use `wscat` to connect to the Flutter VM by running the following command (update endpoint with the correct observatory port):

```shell
wscat -c ws://127.0.0.1:8888/Rvc8E3cGyYQ=/
```

You should see a confirmation message stating that the connection is established.

#### Execute command with `dragAndDropWithCommandExtension`

Find `isolates/id` by running the following command:

```shell
{"jsonrpc": "2.0", "method": "getVM", "params": {}, "id": "1"}
```

Example response:

```json
{
   "jsonrpc":"2.0",
   "result":{
      "type":"VM",
      "name":"vm",
      ...
      "isolates":[
         {
            "type":"@Isolate",
            "id":"isolates/5690600412734227",  // YOUR ISOLATE ID
            "name":"main",
            "number":"5690600412734227",
            "isSystemIsolate":false,
            "isolateGroupId":"isolateGroups/6812870054797830"
         }
      ],
      ...
   },
   "id":"1"
}  
```

Use the isolate id to run the dragAndDropWithCommandExtension command:

```shell
{"jsonrpc":"2.0","method":"ext.flutter.driver","params":{"command":"dragAndDropWithCommandExtension","startX":"205","startY":"116","endX":"0","endY":"172","duration":"20000","isolateId":"isolates/5690600412734227"},"id":"3"}
```

After running the command, the application should perform a drag-n-drop operation from the start point to the end point over the specified duration.

Example response after executing the command:

```json
{"jsonrpc":"2.0","result":{"isError":false,"response":{"success":true},"type":"_extensionType","method":"ext.flutter.driver"},"id":"3"}
```

#### Execute command with `getTextWithCommandExtension`

To execute the command, first retrieve the isolate ID using the example provided earlier.

Then, perform the following command, replacing `isolateId` with the actual value:

```shell
{"jsonrpc":"2.0","method":"ext.flutter.driver","params":{"command":"getTextWithCommandExtension","findBy":"eyJmaW5kZXJUeXBlIjoiQnlWYWx1ZUtleSIsImtleVZhbHVlU3RyaW5nIjoiYW1vdW50Iiwia2V5VmFsdWVUeXBlIjoiU3RyaW5nIn0=","isolateId":"isolates/1229910627242819"},"id":"3"}
```

Example response after executing the command:

```json
{"jsonrpc":"2.0","result":{"isError":false,"response":{"success":true,"text":"Amount: 100 USD"},"type":"_extensionType","method":"ext.flutter.driver"},"id":"3"}
```