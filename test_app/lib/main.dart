import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String gasUrl = String.fromEnvironment('GAS_URL');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カルガモカウンター',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'カルガモカウンター'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _unsentLogs = [];
  int _pressCount = 0;
  DateTime? _lastPressedAt;
  bool _isSending = false;

  void _addLog() {
    final now = DateTime.now();

    int intervalMs = 0;
    if (_lastPressedAt != null) {
      intervalMs = now.difference(_lastPressedAt!).inMilliseconds;
    }

    setState(() {
      _pressCount++;

      _unsentLogs.add({
        'driver_name': 'じゅん',
        'driver_phone': '09000000000',
        'device_id': 'atom-001',
        'press_count': _pressCount,
        'interval_ms': intervalMs,
        'recorded_at': now.toIso8601String(),
        'memo': 'Flutter一括送信テスト2',
      });

      _lastPressedAt = now;
    });
  }

  Future<void> _sendLogs() async {
    if (gasUrl.isEmpty) {
      _showMessage('GAS_URLが設定されていません');
      return;
    }

    if (_unsentLogs.isEmpty) {
      _showMessage('送信するデータがありません');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final response = await http.post(
        Uri.parse(gasUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'logs': _unsentLogs,
        }),
      );
      

      if (response.statusCode == 200 || response.statusCode == 302) {
        final sentCount = _unsentLogs.length;

        setState(() {
          _unsentLogs.clear();
        });

        _showMessage('$sentCount件送信しました');
      } else {
        _showMessage('送信失敗: ${response.statusCode}');
      }

    } catch (e) {
      _showMessage('送信エラー: $e');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _clearLogs() {
    setState(() {
      _unsentLogs.clear();
      _pressCount = 0;
      _lastPressedAt = null;
    });

    _showMessage('未送信データを削除しました');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '未送信件数：${_unsentLogs.length}件',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              '現在のカウント：$_pressCount',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addLog,
              child: const Text('記録する'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isSending ? null : _sendLogs,
              child: Text(_isSending ? '送信中...' : 'まとめて送信'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _clearLogs,
              child: const Text('クリア'),
            ),
            const SizedBox(height: 24),
            const Text(
              '未送信データ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _unsentLogs.length,
                itemBuilder: (context, index) {
                  final log = _unsentLogs[index];

                  return Card(
                    child: ListTile(
                      title: Text('No.${log['press_count']}'),
                      subtitle: Text(
                        'recorded_at: ${log['recorded_at']}\n'
                        'interval_ms: ${log['interval_ms']}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}