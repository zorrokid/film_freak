import 'package:flutter/material.dart';
import 'package:flutter_todo/features/add_release/add_release.dart';
import 'package:flutter_todo/features/scan_results/scan_results_list.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../../realm/schemas.dart';
import '../../services/barcode_scan_service.dart';

class ScanResults extends StatefulWidget {
  final BarcodeScanService barcodeScanService;
  const ScanResults({super.key, required this.barcodeScanService});

  @override
  State<StatefulWidget> createState() {
    return _ScanResultsState();
  }
}

class _ScanResultsState extends State<ScanResults> {
  String _barcode = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> scanBarcode(BuildContext context) async {
    final barcode = (await Navigator.pushNamed(context, '/scan')) as String?;
    if (barcode == null || !mounted) return;
    final realm = Provider.of<Realm?>(context, listen: false);
    if (realm == null) return;
    final exists =
        realm.all<Release>().query('barcode == "$barcode"').isNotEmpty;
    if (exists) {
      setState(() {
        _barcode = barcode;
      });
    } else if (!exists) {
      // when barcode doesn't exist, create a new release with collection item
      final route = MaterialPageRoute<String>(builder: (context) {
        return AddRelease(
          barcode: barcode,
        );
      });

      await Navigator.push(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan results')),
      body: ScanResultsList(barcode: _barcode),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcode(context),
        child: const Icon(Icons.search),
      ),
    );
  }
}
