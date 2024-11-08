import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RFIDService {
  SerialPort? _serialPort;
  String? machineId;
  
  Future<void> connectToScanner() async {
    try {
      final availablePorts = SerialPort.availablePorts;
      if (availablePorts.isNotEmpty) {
        _serialPort = SerialPort(availablePorts[0]);
        if (!_serialPort!.openReadWrite()) {
          throw Exception("Failed to open port!");
        }
        print('Connected to RFID Scanner.');
        machineId = await fetchMachineID();
      } else {
        print("No available ports.");
      }
    } catch (e) {
      print("Error connecting to scanner: $e");
    }
  }

  Future<String> fetchMachineID() async {
    if (_serialPort != null && _serialPort!.isOpen) {
      final reader = SerialPortReader(_serialPort!);
      await for (final data in reader.stream) {
        String receivedData = String.fromCharCodes(data);
        if (receivedData.contains('ID:')) {
          String id = receivedData.split('ID:')[1].trim();
          print('Machine ID: $id');
          return id;
        }
      }
    } else {
      throw Exception('Serial port not open');
    }
    return 'Unknown Machine';
  }

  Stream<String> listenToRFID() async* {
    if (_serialPort != null && _serialPort!.isOpen) {
      final reader = SerialPortReader(_serialPort!);
      await for (final data in reader.stream) {
        String scannedData = String.fromCharCodes(data);
        yield scannedData;
      }
    } else {
      throw Exception('Serial port not opened.');
    }
  }

  Future<double> fetchBalance(String machineId) async {
    final response = await http.get(Uri.parse('https://example.com/api/balance/$machineId'));
    if (response.statusCode == 200) {
      return double.parse(jsonDecode(response.body)['balance']);
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<void> sendRecharge(String machineId, String rfid, double amount) async {
    final response = await http.post(
      Uri.parse('https://example.com/api/recharge'),
      body: jsonEncode({
        'machineId': machineId,
        'rfid': rfid,
        'amount': amount,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to recharge');
    }
  }

  void disconnect() {
    _serialPort?.close();
  }
}
