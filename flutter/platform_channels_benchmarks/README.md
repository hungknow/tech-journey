Benchmark the platform channel that can deliver the message fastest on all platforms.
- [ ] android
- [ ] linux
- [ ] web

Benchmark type of messages:
- Basic primitive types
- List of object
- Convert the list of object into the binary bytes, then send the binary bytes


Run for testing device

Run the android emulator, then execute the following bash script

```shell
flutter run --profile
```

```shell
flutter run -d linux --profile
```

```shell
flutter run -d web --profile
```

```shell
flutter drive --profile \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/app_test.dart \
    -d android
```

```shell
flutter drive --profile \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/app_test.dart \
    -d linux
```

```shell
chromedriver --port=4444

flutter drive --profile \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d web-server
```

Android Result
```
I/flutter ( 5623): BasicMessageChannel/StandardMessageCodec/Flutter->Host/Small: 0.5 µs
I/flutter ( 5623): BasicMessageChannel/StandardMessageCodec/Flutter->Host/Large: 0.9 µs
I/flutter ( 5623): BasicMessageChannel/StandardMessageCodec/Flutter->Host/1MB: 73.1 µs
I/flutter ( 5623): BasicMessageChannel/BinaryCodec/Flutter->Host/Large: 0.1 µs
I/flutter ( 5623): BasicMessageChannel/BinaryCodec/Flutter->Host/LargeEncode: 0.2 µs
I/flutter ( 5623): BasicMessageChannel/BinaryCodec/Flutter->Host/1MBLargeEncode: 34.2 µs
I/flutter ( 5623): BasicMessageChannel/BinaryCodec/Flutter->Host/1MB: 0.8 µs
```

Linux Result
```
BasicMessageChannel/StandardMessageCodec/Flutter->Host/Small: 1.3 µs
BasicMessageChannel/StandardMessageCodec/Flutter->Host/Large: 2.8 µs
BasicMessageChannel/StandardMessageCodec/Flutter->Host/1MB: 56.0 µs
BasicMessageChannel/BinaryCodec/Flutter->Host/Large: 1.5 µs
BasicMessageChannel/BinaryCodec/Flutter->Host/LargeEncode: 1.9 µs
BasicMessageChannel/BinaryCodec/Flutter->Host/1MBLargeEncode: 25.5 µs
BasicMessageChannel/BinaryCodec/Flutter->Host/1MB: 2.5 µs
```