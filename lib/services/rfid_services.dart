import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RFIDService {
  String? machineId;

  
  
  Future<void> connectToScanner() async {

  }

  Future<String> fetchMachineID() async {
    
    return 'Unknown Machine';
  }

  Stream<String> listenToRFID() async* {

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

 
}
