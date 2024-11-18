import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sathwik_app/features/auth/bloc/auth_bloc.dart';
import 'package:sathwik_app/features/auth/pages/login.dart';
import 'package:sathwik_app/features/devicelist/bloc/device_bloc.dart';
import 'package:sathwik_app/features/devicelist/pages/devices_list_page.dart';
import 'package:sathwik_app/features/home/pages/home_page.dart';

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
      initialRoute: token == null ? '/login' : "/blue",
      routes: {
        '/login': (context) => BlocProvider(
              create: (context) => AuthBloc(),
              child: const LoginPage(),
            ),
        '/home': (context) => BlocProvider(
              create: (context) => AuthBloc(),
              child: HomePage(),
            ),
        '/blue': (context) => BlocProvider(
              create: (context) => DeviceBloc(),
              child: const DevicesListPage (),
            ),
      },
    );
  }
}
