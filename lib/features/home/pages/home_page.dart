// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sathwik_app/features/auth/bloc/auth_bloc.dart';
// import 'package:sathwik_app/features/devicelist/pages/devices_list_page.dart';
// import 'package:sathwik_app/features/history/pages/history_page.dart';
// import 'package:sathwik_app/features/home/bloc/connection_bloc.dart';
// import 'package:sathwik_app/services/rfid_services.dart';
// import 'package:sathwik_app/features/auth/pages/login.dart';

// class HomePage extends StatefulWidget {
//   final List<Map<String, dynamic>> rechargeHistory = [];
//   HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController machineIdController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController rfidController = TextEditingController();
//   final RFIDService rfidService = RFIDService();

//   String? machineId;
//   double? machineBalance;
//   String? scannedRFID;
//   bool isloading = false;
//   bool isConnected = false;

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     widget.rechargeHistory.addAll([
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 900.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5698',
//         'amount': 200.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 100.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 100.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 100.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 100.0,
//         'time': DateTime.now(),
//       },
//       {
//         'machineId': 'MACHINE1234',
//         'rfid': 'RFID5678',
//         'amount': 100.0,
//         'time': DateTime.now(),
//       },
//     ]);

//     // _connectToMachine();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

//     _controller.forward();
//   }

//   Future<void> _connectToMachine() async {
//     setState(() {
//       isloading = true;
//     });
//     try {
//       await rfidService.connectToScanner();
//       String id = await rfidService.fetchMachineID();
//       machineIdController.text = id;
//       await _fetchBalanceForMachine(id);
//       setState(() {
//         isConnected = true;
//       });
//     } catch (error) {
//       _showErrorDialog('Failed to connect to machine');
//     } finally {
//       setState(() {
//         isloading = false;
//       });
//     }
//   }

//   Future<void> _fetchBalanceForMachine(String machineId) async {
//     try {
//       double balance = await rfidService.fetchBalance(machineId);
//       setState(() {
//         machineBalance = balance;
//       });
//     } catch (error) {
//       _showErrorDialog('Failed to fetch balance');
//     }
//   }

//   Future<void> _recharge() async {
//     double amount = double.tryParse(amountController.text) ?? 0.0;
//     if (amount > machineBalance!) {
//       _showErrorDialog('Recharge amount exceeds machine balance.');
//       return;
//     }

//     try {
//       await rfidService.sendRecharge(
//           machineIdController.text, scannedRFID!, amount);

//       setState(() {
//         widget.rechargeHistory.add({
//           'machineId': machineIdController.text,
//           'rfid': scannedRFID!,
//           'amount': amount,
//           'time': DateTime.now(),
//         });
//       });

//       _showSuccessDialog('Recharge successful!');
//     } catch (e) {
//       _showErrorDialog('Failed to recharge: $e');
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _validateRechargeInput() {
//     if (machineIdController.text.isEmpty) {
//       _showErrorDialog('Machine ID not available.');
//       return false;
//     }

//     if (scannedRFID == null || scannedRFID!.isEmpty) {
//       _showErrorDialog('RFID not scanned.');
//       return false;
//     }

//     double? amount = double.tryParse(amountController.text);
//     if (amount == null || amount <= 0) {
//       _showErrorDialog('Please enter a valid recharge amount.');
//       return false;
//     }

//     if (amount > machineBalance!) {
//       _showErrorDialog('Recharge amount exceeds machine balance.');
//       return false;
//     }

//     return true;
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Success'),
//         content: Text(message),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     // rfidService.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthLogoutSuccessState) {
//           Navigator.pushReplacementNamed(context, "/login");
//         }
//         if (state is AuthLogoutFailureState) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(state.message)));
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: ElevatedButton.icon(
//               onPressed: () {
//                 context.read<AuthBloc>().add(AuthLogoutEvent());

//                 //  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
//               },
//               label: const Icon(
//                 Icons.logout_outlined,
//                 size: 30,
//               )),
//           title: const Text("V-Charge ₹",
//               style:
//                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => HistoryPage(
//                             rechargeHistory: widget.rechargeHistory)),
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.history,
//                   color: Colors.white,
//                   size: 30,
//                 )),
//           ],
//         ),
//         body: isloading
//             ? const Center(child: CircularProgressIndicator())
//             : Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
//                 child: Column(
//                   children: [
//                     FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Column(
//                         children: [
//                           const Icon(
//                             Icons.currency_rupee,
//                             size: 70,
//                             color: Colors.black,
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             "Let's Recharge!",
//                             style: GoogleFonts.nunito(
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         _connectToMachine();
//                       },
//                       icon: const Icon(Icons.device_hub_outlined),
//                       label: Text(
//                         'Connect to Machine',
//                         style: GoogleFonts.nunito(),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         minimumSize: const Size(400, 45),
//                         textStyle: const TextStyle(fontSize: 18),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     TextFormField(
//                       controller: machineIdController,
//                       decoration: InputDecoration(
//                         labelText: 'Machine ID',
//                         labelStyle: GoogleFonts.nunito(
//                             fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                       readOnly: true,
//                     ),
//                     const SizedBox(height: 20),
//                     if (machineBalance != null)
//                       Text(
//                         'Balance: \$${machineBalance!.toStringAsFixed(2)}',
//                         style:
//                             const TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                     const SizedBox(height: 30),
//                     TextFormField(
//                       controller: rfidController,
//                       decoration: InputDecoration(
//                         labelText: 'RFID',
//                         labelStyle: GoogleFonts.nunito(
//                             fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                       readOnly: true,
//                     ),
//                     const SizedBox(height: 50),
//                     TextFormField(
//                       controller: amountController,
//                       decoration: InputDecoration(
//                         labelText: 'Amount',
//                         labelStyle: GoogleFonts.nunito(
//                             fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                       keyboardType: TextInputType.number,
//                       cursorColor: Colors.black,
//                     ),
//                     const SizedBox(height: 40),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_validateRechargeInput()) {
//                           _recharge();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         minimumSize: const Size(400, 60),
//                       ),
//                       child: Text(
//                         'RECHARGE  ₹',
//                         style: GoogleFonts.nunito(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/features/devicelist/pages/devices_list_page.dart';
import 'package:sathwik_app/features/home/bloc/connection_bloc.dart';
import 'package:sathwik_app/features/home/bloc/recharge_bloc.dart';
import 'package:sathwik_app/features/home/widgets/custom_text_field.dart';

class HomePage extends StatefulWidget {
  final String address;
  const HomePage({super.key, required this.address,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _machineIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String balance = "0";
  String rfidBalance = "0";
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConnectionBloc>(context).add(
      ConnectToMachineEvent(
        address: widget.address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectionBloc, ConnectionsState>(
          listener: (context, state) {
            if (state is ConnectToMachineSuccessState) {
              setState(() {
                _machineIdController.text = state.machineId;
                balance = state.amount;
                connection = state.connection;
              });
            }
          },
        ),
        BlocListener<RechargeBloc , RechargeState>(
          listener: (context, state) {
            if(state is FetchCardBalanceSuccessState) {
              setState(() {
                rfidBalance = state.balance;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Recharge",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "₹ $balance",
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
                            const SizedBox(
                height: 20,
              ),
              Text(
                "₹ $rfidBalance",
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              CustomTextField(
                controller: _machineIdController,
                enabled: false,
              ),
              const SizedBox(
                height: 60,
              ),
              CustomTextField(
                controller: _amountController,
                enabled: true,
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(onPressed: (){
                BlocProvider.of<RechargeBloc>(context).add(
                  FetchCardBalance(connection: connection!), 
                );
              }, child:const Text("Check Balance")),
            ],
          ),
        ),
      ),
    );
  }
}
