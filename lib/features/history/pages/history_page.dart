import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> rechargeHistory;

  const HistoryPage({super.key, required this.rechargeHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

       leading: IconButton(onPressed: (){
        Navigator.pop(context);
       }, icon:const Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text('Recharge History', style: TextStyle(color: Colors.white)),
      ),
      body: rechargeHistory.isEmpty
          ? const Center(
              child: Text('No recharge history available.'),
            )
          : ListView.builder(
              itemCount: rechargeHistory.length,
              itemBuilder: (context, index) {
                final historyItem = rechargeHistory[index];
                return Card(
                  margin: const EdgeInsets.all(15.0),
                  child: ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text('Machine ID: ${historyItem['machineId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RFID: ${historyItem['rfid']}'),
                        Text('Amount: ₹${historyItem['amount']}'),
                        Text('Time: ${historyItem['time']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}