import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_channels_benchmarks/microbenchmark.dart';

List<Object?> _makeTestBuffer(int size) {
  final List<Object?> answer = <Object?>[];
  for (int i = 0; i < size; ++i) {
    switch (i % 9) {
      case 0:
        answer.add(1);
        break;
      case 1:
        answer.add(math.pow(2, 65));
        break;
      case 2:
        answer.add(1234.0);
        break;
      case 3:
        answer.add(null);
        break;
      case 4:
        answer.add(<int>[1234]);
        break;
      case 5:
        answer.add(<String, int>{'hello': 1234});
        break;
      case 6:
        answer.add('this is a test');
        break;
      case 7:
        answer.add(true);
        break;
      case 8:
        answer.add(Uint8List(64));
        break;
    }
  }

  return answer;
}

Future<double> _runBasicStandardSmall(
    BasicMessageChannel<Object?> channel, int count) async {
  final Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < count; ++i) {
    await channel.send(1234);
  }
  stopwatch.stop();
  return stopwatch.elapsedMilliseconds / count;
}

Future<double> _runBasicStandardLarge(BasicMessageChannel<Object?> channel,
    List<Object?> largeBuffer, int count) async {
  int size = 0;
  final Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < count; ++i) {
    final List<Object?> largeBufferReply =
        await channel.send(largeBuffer) as List<Object?>;
    size += largeBufferReply.length;
  }
  stopwatch.stop();

  if (size != largeBuffer.length * count) {
    throw Exception(
      "There is an error with the echo channel, the results don't add up: $size",
    );
  }

  return stopwatch.elapsedMilliseconds / count;
}

Future<double> _runBasicBinaryByEncode(BasicMessageChannel<ByteData> channel,
    List<Object?> largeObjectList, int count) async {
  int size = 0;
  final Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < count; ++i) {
    ByteData buffer =
        const StandardMessageCodec().encodeMessage(largeObjectList)!;
    final ByteData? result = await channel.send(buffer);
    if (buffer.lengthInBytes != buffer.lengthInBytes) {
      throw Exception(
        "There is an error with the echo channel, the results don't add up: $size",
      );
    }

    size += (result == null) ? 0 : result.lengthInBytes;
  }
  stopwatch.stop();

  return stopwatch.elapsedMilliseconds / count;
}

Future<double> _runBasicBinary(
    BasicMessageChannel<ByteData> channel, ByteData buffer, int count) async {
  int size = 0;
  final Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (int i = 0; i < count; ++i) {
    final ByteData? result = await channel.send(buffer);
    size += (result == null) ? 0 : result.lengthInBytes;
  }
  stopwatch.stop();

  if (size != buffer.lengthInBytes * count) {
    throw Exception(
      "There is an error with the echo channel, the results don't add up: $size",
    );
  }

  return stopwatch.elapsedMilliseconds / count;
}

Future<void> _runTests() async {
  if (kDebugMode) {
    throw Exception(
      "Must be run in profile mode! Use 'flutter run --profile'.",
    );
  }

  final List<Object?> largeBuffer = _makeTestBuffer(1000);
  final ByteData largeBufferBytes =
      const StandardMessageCodec().encodeMessage(largeBuffer)!;
  final ByteData oneMB = ByteData(1024 * 1024);
  final List<double> oneMbOfInteger =
      List.filled((1024 * 1024 / 8).ceil(), 0x7FFFFFFF);

  const BasicMessageChannel<Object?> resetChannel =
      BasicMessageChannel<Object?>("hungknow.reset", StandardMessageCodec());
  const BasicMessageChannel<Object?> basicStandard =
      BasicMessageChannel<Object?>(
          "hungknow.basic.standard", StandardMessageCodec());
  const BasicMessageChannel<ByteData> basicBinary =
      BasicMessageChannel<ByteData>("hungknow.basic.binary", BinaryCodec());

  const int numMessages = 2500;

  final BenchmarkResultPrinter printer = BenchmarkResultPrinter();
  resetChannel.send(true);
  await _runBasicStandardSmall(basicStandard, 1);
  printer.addResult(
    description: 'BasicMessageChannel/StandardMessageCodec/Flutter->Host/Small',
    value: await _runBasicStandardSmall(basicStandard, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_standard_2host_small',
  );

  resetChannel.send(true);
  await _runBasicStandardLarge(basicStandard, largeBuffer, 1);
  printer.addResult(
    description: 'BasicMessageChannel/StandardMessageCodec/Flutter->Host/Large',
    value:
        await _runBasicStandardLarge(basicStandard, largeBuffer, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_standard_2host_large',
  );

  resetChannel.send(true);
  await _runBasicStandardLarge(basicStandard, oneMbOfInteger, 1); // Warmup.
  printer.addResult(
    description: 'BasicMessageChannel/StandardMessageCodec/Flutter->Host/1MB',
    value: await _runBasicStandardLarge(
        basicStandard, oneMbOfInteger, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_standard_2host_1MB',
  );

  resetChannel.send(true);
  await _runBasicBinary(basicBinary, largeBufferBytes, 1); // Warmup.
  printer.addResult(
    description: 'BasicMessageChannel/BinaryCodec/Flutter->Host/Large',
    value: await _runBasicBinary(basicBinary, largeBufferBytes, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_binary_2host_large',
  );

  resetChannel.send(true);
  await _runBasicBinaryByEncode(basicBinary, largeBuffer, 1); // Warmup.
  printer.addResult(
    description: 'BasicMessageChannel/BinaryCodec/Flutter->Host/LargeEncode',
    value: await _runBasicBinaryByEncode(basicBinary, largeBuffer, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_binary_2host_largeencode',
  );

  resetChannel.send(true);
  await _runBasicBinaryByEncode(basicBinary, oneMbOfInteger, 1); // Warmup.
  printer.addResult(
    description: 'BasicMessageChannel/BinaryCodec/Flutter->Host/1MBLargeEncode',
    value:
        await _runBasicBinaryByEncode(basicBinary, oneMbOfInteger, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_binary_2host_1mblargeencode',
  );

  resetChannel.send(true);
  await _runBasicBinary(basicBinary, oneMB, 1); // Warmup.
  printer.addResult(
    description: 'BasicMessageChannel/BinaryCodec/Flutter->Host/1MB',
    value: await _runBasicBinary(basicBinary, oneMB, numMessages),
    unit: 'µs',
    name: 'platform_channel_basic_binary_2host_1MB',
  );

  printer.printToStdout();
}

class _BenchmarkWidget extends StatefulWidget {
  const _BenchmarkWidget(this.tests, {Key? key}) : super(key: key);

  final Future<void> Function() tests;

  @override
  _BenchmarkWidgetState createState() => _BenchmarkWidgetState();
}

class _BenchmarkWidgetState extends State<_BenchmarkWidget> {
  @override
  void initState() {
    widget.tests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container();
}

void main() {
  runApp(const _BenchmarkWidget(_runTests));
}
