import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sathwik_app/features/auth/bloc/auth_bloc.dart';
import 'package:sathwik_app/features/auth/pages/login.dart';
import 'package:sathwik_app/features/connect_to_machine_page/bloc/initial_transaction_bloc.dart';
import 'package:sathwik_app/features/connect_to_machine_page/pages/connect_to_machine_page.dart';
import 'package:sathwik_app/features/devicelist/pair_device_bloc/pair_device_bloc.dart';
import 'package:sathwik_app/features/devicelist/paired_device_bloc/device_bloc.dart';
import 'package:sathwik_app/features/devicelist/unpaired_device_bloc/unpaired_devices_bloc.dart';
import 'package:sathwik_app/features/devicelist/pages/devices_list_page.dart';
import 'package:sathwik_app/features/recharge/bloc/recharge_bloc.dart';
import 'package:sathwik_app/features/recharge/pages/recharge_page.dart';
import 'package:sathwik_app/features/success_page/pages/success_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appPath = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  var box = await Hive.openBox("authtoken");
  var token = box.get("token");
  box.close();
  runApp(MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Recharge App 📱',
      initialRoute: token == null ? '/login' : "/devicelist",
      routes: {
        '/recharge': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as RechargeArgs?;
          return BlocProvider(
            create: (context) => RechargeBloc(),
            child: RechargePage(
              balance: args!.balance,
              machineId: args.machineID,
              address: args.address,
            ),
          );
        },
        '/login': (context) => BlocProvider(
              create: (context) => AuthBloc(),
              child: const LoginPage(),
            ),
        '/connecttomachine': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as ArgsBlu?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => InitialTransactionBloc(),
              ),
            ],
            child: ConnectToMachinePage(
              address: args!.address,
            ),
          );
        },
        '/success': (context) {
           final args = ModalRoute.of(context)?.settings.arguments as FinalArgs?;
          return  SuccessPage(
            message: args!.message,
            state: args.state,
          );
        },
        '/devicelist': (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => DeviceBloc(),
                ),
                BlocProvider(
                  create: (context) => UnpairedDevicesBloc(),
                ),
                BlocProvider(
                  create: (context) => PairDeviceBloc(),
                ),
              ],
              child: const DevicesListPage(),
            ),
      },
    );
  }
}
