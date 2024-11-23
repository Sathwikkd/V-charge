import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/features/history/bloc/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  final String machineId;
  const HistoryPage({super.key, required this.machineId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HistoryBloc>(context).add(
      FetchHistoryEvent(machineId: widget.machineId),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text(
          "History",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is FetchHistorySuccessState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(widget.machineId),
                  subtitle: Text(state.data[index]["timestamp"]),
                  trailing: Text(state.data[index]["amount"].toString()),
                );
              },
              itemCount: state.data.length,
            );
          } else if (state is FetchHistoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeCap: StrokeCap.round,
              ),
            );
          } else if (state is FetchHistoryErrorState) {
            return Column(
              children: [
                const Icon(Icons.error),
                const Text("Something Went Wrong..."),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<HistoryBloc>(context).add(
                      FetchHistoryEvent(machineId: widget.machineId),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Retry",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeCap: StrokeCap.round,
            ),
          );
        },
      ),
    );
  }
}
