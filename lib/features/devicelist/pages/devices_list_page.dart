import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sathwik_app/core/common/custom_snackbar.dart';
import 'package:sathwik_app/features/devicelist/pair_device_bloc/pair_device_bloc.dart';
import 'package:sathwik_app/features/devicelist/paired_device_bloc/device_bloc.dart';
import 'package:sathwik_app/features/devicelist/unpaired_device_bloc/unpaired_devices_bloc.dart';

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

  List<BluetoothDiscoveryResult> upDevices = [];
  List<BluetoothDevice> devices = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeviceBloc, DeviceState>(
          listener: (context, state) async {
            if (state is PermissionSuccessState) {
              BlocProvider.of<DeviceBloc>(context).add(
                CheckConnectionEvent(),
              );
            }
            if (state is ConnectionFailureState) {
              bool? isEnabled =
                  await FlutterBluetoothSerial.instance.requestEnable();
              if (isEnabled == null || !isEnabled) {
                SystemNavigator.pop();
              }
              BlocProvider.of<DeviceBloc>(context)
                  .add(FetchBluetoothDevicesEvent());
              BlocProvider.of<UnpairedDevicesBloc>(context).add(
                FetchUnpairedDevices(),
              );
            }
            if (state is ConnectionSuccessState) {
              BlocProvider.of<DeviceBloc>(context)
                  .add(FetchBluetoothDevicesEvent());
              BlocProvider.of<UnpairedDevicesBloc>(context).add(
                FetchUnpairedDevices(),
              );
            }
          },
        ),
        BlocListener<PairDeviceBloc, PairDeviceState>(
            listener: (context, state) {
          if (state is PairingDeviceErrorState) {
            Snackbar.showSnackbar(
              message: state.message,
              leadingIcon: Icons.error,
              context: context,
            );
          }
        }),
      ],
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
                BlocProvider.of<DeviceBloc>(context)
                    .add(CheckConnectionEvent());
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Paired Devices",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<DeviceBloc, DeviceState>(
                builder: (context, state) {
                  if (state is FetchDeviceSuccesState) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/connecttomachine",
                              arguments: ArgsBlus(
                                address: state.devices[index].address,
                                mid: state.devices[index].name.toString(),
                              ),
                            );
                          },
                          title: Text(
                            state.devices[index].name.toString(),
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            state.devices[index].address,
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.bluetooth,
                            color: Colors.grey.shade600,
                            size: 26,
                          ),
                          trailing: Icon(
                            Icons.arrow_outward_rounded,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                      itemCount: state.devices.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                    );
                  } else if (state is FetchDeviceErrorState) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          state.message,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    );
                  } else if (state is LoadingState) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Unpaired Devices",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<UnpairedDevicesBloc, UnpairedDevicesState>(
                builder: (context, state) {
                  if (state is FetchUnpairedDevicesSuccessState) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            BlocProvider.of<PairDeviceBloc>(context).add(
                              PairingDeviceEvent(
                                address: state.updevices[index].device.address,
                              ),
                            );
                          },
                          title: Text(
                            state.updevices[index].device.name ?? "Undefined",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            state.updevices[index].device.address,
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          leading: Icon(
                            Icons.bluetooth,
                            color: Colors.grey.shade600,
                            size: 26,
                          ),
                          trailing: Icon(
                            Icons.arrow_outward_rounded,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                      itemCount: state.updevices.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                    );
                  } else if (state is FetchUnpairedDevicesErrorState) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          state.message,
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    );
                  } else if (state is FetchUnpairedDevicesLoadingState) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArgsBlus {
  final String address;
  final String mid;
  ArgsBlus({required this.address , required this.mid});
}
