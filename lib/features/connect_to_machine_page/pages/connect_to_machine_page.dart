import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sathwik_app/core/common/custom_snackbar.dart';
import 'package:sathwik_app/features/connect_to_machine_page/bloc/initial_transaction_bloc.dart';
import 'package:sathwik_app/features/devicelist/pages/devices_list_page.dart';
import 'package:sathwik_app/features/history/bloc/history_bloc.dart';
import 'package:sathwik_app/features/history/pages/history_page.dart';

class ConnectToMachinePage extends StatefulWidget {
  final String address;
  final String mid;
  const ConnectToMachinePage(
      {super.key, required this.address, required this.mid});

  @override
  State<ConnectToMachinePage> createState() => _ConnectToMachinePageState();
}

class _ConnectToMachinePageState extends State<ConnectToMachinePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cardAnimationController;
  bool isCheckBluetoothButton = true;
  bool isRecharge = false;
  String machineId = "Please Place The Card";
  String balance = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Smooth forward-only animation
    );
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitialTransactionBloc, InitialTransactionState>(
      listener: (context, state) {
        if (state is FetchAllDetailsSuccessState) {
          setState(() {
            machineId = state.machineId;
            balance = state.balance;
            _isLoading = false;
            isRecharge = true;
            isCheckBluetoothButton = false;
            _cardAnimationController.value = 0.3;
          });
          // Play animation forward to 100%
        }
        if (state is FetchAllDetailsErrorState) {
          Snackbar.showSnackbar(
            message: state.message,
            leadingIcon: Icons.error,
            context: context,
          );
          setState(() {
            isCheckBluetoothButton = true;
            _isLoading = false;
          });
        }
        if (state is FetchAllDetaailsLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => HistoryBloc(),
                                child: HistoryPage(machineId: widget.mid),
                              )));
                },
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                )),
          ],
          centerTitle: false,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.black,
          title: Text(
            "Connect To Machine",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "ID: $machineId",
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: isRecharge
                      ? Text(
                          "₹ $balance",
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            Center(
              child: Lottie.asset(
                "assets/Animation.json",
                controller: _cardAnimationController,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 160,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: isCheckBluetoothButton
                        ? () {
                            setState(() {
                              isCheckBluetoothButton = false;
                            });
                            BlocProvider.of<InitialTransactionBloc>(context)
                                .add(
                              FetchAllDetailsEvent(
                                address: widget.address,
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey.shade800,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fixedSize:
                            Size(MediaQuery.of(context).size.width - 20, 60)),
                    child: _isLoading
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                            ),
                          )
                        : Text(
                            "Check For Card",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: isRecharge
                        ? () {
                            Navigator.pushNamed(
                              context,
                              "/recharge",
                              arguments: RechargeArgs(
                                address: widget.address,
                                balance: balance,
                                machineID: machineId,
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width - 20, 60),
                    ),
                    child: Text(
                      "Recharge",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RechargeArgs {
  final String machineID;
  final String balance;
  final String address;
  RechargeArgs({
    required this.balance,
    required this.machineID,
    required this.address,
  });
}
