import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/features/devicelist/bloc/device_bloc.dart';

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({super.key});

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DeviceBloc>(context).add(
      HandlePermissionEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceBloc, DeviceState>(
      listener: (context, state) {
        if (state is PermissionSuccessState) {
          BlocProvider.of<DeviceBloc>(context).add(
            FetchBluetoothDevicesEvent(),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Bluetooth Devices",
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<DeviceBloc>(context).add(
                  FetchBluetoothDevicesEvent(),
                );
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            if (state is FetchDeviceSuccesState) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: state.devices.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/home",
                            arguments: ArgsBlu(
                              address: state.devices[index].address,
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(state.devices[index].name.toString()),
                          subtitle: Text(state.devices[index].address),
                          leading: const Icon(Icons.bluetooth),
                          trailing: const Icon(Icons.arrow_outward_rounded),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (state is FetchDeviceErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    Text(state.message),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeCap: StrokeCap.round,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ArgsBlu {
  final String address;
  ArgsBlu({required this.address});
}
