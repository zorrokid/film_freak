import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_todo/services/barcode_scan_service.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/app_services.dart';
import 'package:flutter_todo/realm/init_realm.dart';
import 'package:flutter_todo/screens/homepage.dart';
import 'package:flutter_todo/screens/log_in.dart';
import 'features/scan/scan.dart';
import 'features/scan_results/scan_results.dart';

// TODO: move to app state
List<CameraDescription> cameras = [];

void main() async {
  // get app id from config
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final realmConfig =
      json.decode(await rootBundle.loadString('assets/config/realm.json'));
  String appId = realmConfig['appId'];
  Uri baseUrl = Uri.parse(realmConfig['baseUrl']);

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppServices>(
        create: (_) => AppServices(appId, baseUrl)),
    ProxyProvider<AppServices, Realm?>(
      update: (context, app, previousRealm) {
        if (app.currentUser != null) {
          previousRealm?.close();
          return initRealm(app.currentUser!);
        }
        return null;
      },
      dispose: (_, realm) => realm?.close(),
    )
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<AppServices>(context, listen: false).currentUser;
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        title: 'film_freak',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: currentUser != null ? '/' : '/login',
        routes: {
          '/home': (context) => const HomePage(),
          '/login': (context) => LogIn(),
          '/': (context) => ScanResults(
                barcodeScanService: BarcodeScanService(),
              ),
          '/scan': (context) => const Scan(),
        },
      ),
    );
  }
}
