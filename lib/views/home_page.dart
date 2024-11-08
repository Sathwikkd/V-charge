import 'package:flutter/material.dart';
import 'package:v_charge/services/rfid_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController machineIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rfidController = TextEditingController();
  final RFIDService rfidService = RFIDService();

  String? machineId;
  double? machineBalance;
  String? scannedRFID;
  bool isloading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _connectToMachine();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }

  Future<void> _connectToMachine() async {
    setState(() {
      isloading = true;
    });
    try {
      await rfidService.connectToScanner();
      String id = await rfidService.fetchMachineID();
      machineIdController.text = id;
      await _fetchBalanceForMachine(id);
    } catch (error) {
      _showErrorDialog('Failed to connect to machine: $error');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> _fetchBalanceForMachine(String machineId) async {
    try {
      double balance = await rfidService.fetchBalance(machineId);
      setState(() {
        machineBalance = balance;
      });
    } catch (error) {
      _showErrorDialog('Failed to fetch balance');
    }
  }

  Future<void> _recharge() async {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount > machineBalance!) {
      _showErrorDialog('Recharge amount exceeds machine balance.');
      return;
    }

    try {
      await rfidService.sendRecharge(machineIdController.text, scannedRFID!, amount);
      _showSuccessDialog('Recharge successful!');
    } catch (e) {
      _showErrorDialog('Failed to recharge: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _validateRechargeInput() {
    if (machineIdController.text.isEmpty) {
      _showErrorDialog('Machine ID not available.');
      return false;
    }

    if (scannedRFID == null || scannedRFID!.isEmpty) {
      _showErrorDialog('RFID not scanned.');
      return false;
    }

    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      _showErrorDialog('Please enter a valid recharge amount.');
      return false;
    }

    if (amount > machineBalance!) {
      _showErrorDialog('Recharge amount exceeds machine balance.');
      return false;
    }

    return true;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); 
    rfidService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("V-Charge", style: TextStyle(color: Colors.white)),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Column(
                      children: [
                        Icon(Icons.currency_rupee, size: 70, color: Colors.black),
                         SizedBox(height: 20),
                         Text(
                          "Let's Recharge!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: machineIdController,
                    decoration: const InputDecoration(labelText: 'Machine ID', labelStyle: TextStyle(color: Colors.black)),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  if (machineBalance != null)
                    Text(
                      'Balance: \$${machineBalance!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: rfidController,
                    decoration: const InputDecoration(labelText: 'RFID', labelStyle: TextStyle(color: Colors.black)),
                    readOnly: true,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount', labelStyle: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateRechargeInput()) {
                        _recharge();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(330, 60),
                    ),
                    child: const Text(
                      'Recharge',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
