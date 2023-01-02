import 'package:flutter/material.dart';
import 'package:flutter_todo/features/add_release/add_release.dart';
import 'package:flutter_todo/features/scan_results/scan_results_list.dart';
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
  late List<Release> _releases;

  @override
  void initState() {
    super.initState();
    _releases = [];
  }

  Future<void> scanBarcode(BuildContext context) async {
    final barcode = (await Navigator.pushNamed(context, '/scan')) as String?;
    if (barcode == null) return;
    final exists = widget.barcodeScanService.exists(barcode);
    if (!mounted) return;
    if (exists) {
      setState(() {
        _releases = widget.barcodeScanService.getReleases(barcode);
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
      body: ScanResultsList(releases: _releases),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcode(context),
        child: const Icon(Icons.search),
      ),
    );
  }
}
