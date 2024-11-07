import 'package:flutter/material.dart';
import 'package:v_charge/services/rfid_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController machineIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rfidController = TextEditingController();
  final RFIDService rfidService = RFIDService();
  
  String? machineId;
  double? balance;

  @override
  void initState() {
    super.initState();
    _connectToMachine();
    listenForRFID();
  }

  void _connectToMachine() async {
    try {
      await rfidService.connectToScanner();
      machineId = await rfidService.fetchMachineID();
      machineIdController.text = machineId!;
      fetchBalanceForMachine();
    } catch (error) {
      _showErrorDialog('Failed to connect to machine');
    }
  }

  void fetchBalanceForMachine() async {
    try {
      balance = await rfidService.fetchBalance(machineId!);
      setState(() {});
    } catch (error) {
      _showErrorDialog('Failed to fetch balance');
    }
  }

  void listenForRFID() async {
    await for (final data in rfidService.listenToRFID()) {
      setState(() {
        rfidController.text = data;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitRecharge() async {
    try {
      double rechargeAmount = double.parse(amountController.text);
      if (rechargeAmount > balance!) {
        _showErrorDialog('Recharge amount exceeds balance');
        return;
      }

      await rfidService.sendRecharge(machineId!, rfidController.text, rechargeAmount);
      _showSuccessDialog('Recharge successful');
    } catch (error) {
      _showErrorDialog('Failed to process recharge');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    rfidService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recharge Machine',style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (balance != null)
              Text('Balance: \$${balance!.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            TextFormField(
              controller: machineIdController,
              decoration: InputDecoration(
                labelText: 'Machine ID',
                filled: true,
                fillColor: Colors.grey,
                contentPadding: EdgeInsets.all(15),
                ),
              readOnly: true,
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: rfidController,
              
              decoration:InputDecoration(
                labelText: 'RFID ID',
                filled: true,
                fillColor: Colors.grey,
                contentPadding: EdgeInsets.all(15),
                ),
              
              readOnly: true,
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                
                labelText: 'Amount',
                filled: true,
                fillColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black,width: 2.0
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: _submitRecharge,
              child: Text('Recharge'),
            ),
          ],
        ),
      ),
    );
  }
}
