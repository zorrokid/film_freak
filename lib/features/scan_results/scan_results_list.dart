import 'package:flutter/material.dart';

import '../../realm/schemas.dart';

class ScanResultsList extends StatelessWidget {
  final List<Release> releases;
  const ScanResultsList({super.key, required this.releases});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: releases.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(releases[index].title),
          subtitle: Text(releases[index].barcode),
        );
      },
    );
  }
}
