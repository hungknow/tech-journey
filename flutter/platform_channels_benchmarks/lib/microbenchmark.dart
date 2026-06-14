import 'dart:convert';


class BenchmarkResultPrinter {
  final List<_BenchmarkResult> _results = <_BenchmarkResult>[];
  void addResult(
      {required String description,
      required double value,
      required String unit,
      required String name}) {
    _results.add(_BenchmarkResult(description, value, unit, name));
  }

  void printToStdout() {
    // IMPORTANT: keep these values in sync with dev/devicelab/bin/tasks/microbenchmarks.dart
    const String jsonStart = '================ RESULTS ================';
    const String jsonEnd = '================ FORMATTED ==============';
    const String jsonPrefix = ':::JSON:::';

    print(jsonStart);
    print('$jsonPrefix ${_printJson()}');
    print(jsonEnd);
    print(_printPlainText());
  }

  String _printJson() {
    final Map<String, double> results = <String, double>{};
    for (final _BenchmarkResult result in _results) {
      results[result.name] = result.value;
    }
    return json.encode(results);
  }

  String _printPlainText() {
    final StringBuffer buf = StringBuffer();
    for (final _BenchmarkResult result in _results) {
      buf.writeln(
          '${result.description}: ${result.value.toStringAsFixed(1)} ${result.unit}');
    }
    return buf.toString();
  }
}

class _BenchmarkResult {
  _BenchmarkResult(this.description, this.value, this.unit, this.name);
  final String description;
  final double value;
  final String unit;
  final String name;
}
