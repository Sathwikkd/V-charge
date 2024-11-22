import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/features/recharge/bloc/recharge_bloc.dart';

class RechargePage extends StatefulWidget {
  final String machineId;
  final String balance;
  final String address;
  const RechargePage({
    super.key,
    required this.balance,
    required this.address,
    required this.machineId,
  });

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final TextEditingController _amountController = TextEditingController();
  String mBalance = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RechargeBloc>(context).add(
      FetchMachineBalanceEvent(machineID: widget.machineId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RechargeBloc, RechargeState>(
      listener: (context, state) {
        if (state is FetchMachineBalanceSuccessState) {
          setState(() {
            mBalance = state.mbalance;
          });
        }
        if (state is RechargeCardSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/success",
            (Route<dynamic> route) => false,
            arguments: FinalArgs(
              message: state.message,
              state: true,
            ),
          );
        }
        if (state is RechargeCardErrorState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/success",
            (Route<dynamic> route) => false,
            arguments: FinalArgs(
              message: state.message,
              state: false,
            ),
          );
        }
         if (state is FetchMachineBalanceFailureState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/success",
            (Route<dynamic> route) => false,
            arguments: FinalArgs(
              message: state.message,
              state: false,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Recharge Page",
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 30,
          ),
        ),
        body: BlocBuilder<RechargeBloc, RechargeState>(
          builder: (context, state) {
            if (state is FetchMachineBalanceLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeCap: StrokeCap.round,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Machine ID: ${widget.machineId}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Machine Balance: $mBalance",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Card Balance: ${widget.balance}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: TextField(
                    controller: _amountController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: GoogleFonts.roboto(color: Colors.black),
                      border: _inputBorder(),
                      enabledBorder: _inputBorder(),
                      disabledBorder: _inputBorder(),
                      errorBorder: _inputBorder(),
                      focusedBorder: _inputBorder(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(5),
          height: 70,
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<RechargeBloc>(context).add(
                RechargeCardEvent(
                  machineID: widget.machineId,
                  address: widget.address,
                  balance: widget.balance,
                  amount: _amountController.text,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 70),
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: BlocBuilder<RechargeBloc, RechargeState>(
              builder: (context, state) {
                if(state is RechargeCardLoadingState){
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                }
                return Text(
                  "Recharge",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    );
  }
}

class FinalArgs {
  final String message;
  final bool state;
  FinalArgs({
    required this.message,
    required this.state,
  });
}
