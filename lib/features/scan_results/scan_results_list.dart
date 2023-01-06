import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../../realm/app_services.dart';
import '../../realm/schemas.dart';
import '../../viewmodels/release_viewmodel.dart';

class ScanResultsList extends StatefulWidget {
  final String barcode;
  const ScanResultsList({super.key, required this.barcode});

  @override
  State<StatefulWidget> createState() => _ScanResultsListState();
}

class _ScanResultsListState extends State<ScanResultsList> {
  final _releaseViewmodels = <ReleaseViewmodel>[];

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppServices>(context).currentUser;
    final realm = Provider.of<Realm?>(context);
    if (realm == null) {
      return Container();
    }
    final stream = realm
        .query<Release>(
            'owner_id == "${currentUser?.id}" AND barcode == "${widget.barcode}"')
        .changes;

    return StreamBuilder<RealmResultsChanges<Release>>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          // While we wait for data to load..
          return Container(
            padding: const EdgeInsets.only(top: 25),
            child: const Center(child: Text("No releases yet.")),
          );
        }

        final releases = data.results;

        // Handle deletions. These are handles first, as indexes refer to the old collection
        for (final deletionIndex in data.deleted) {
          _releaseViewmodels
              .removeAt(deletionIndex); // update view model collection
        }

        // Handle inserts
        for (final insertionIndex in data.inserted) {
          _releaseViewmodels.insert(insertionIndex,
              ReleaseViewmodel(realm, releases[insertionIndex]));
        }

        // Handle modifications
        for (final modifiedIndex in data.modified) {
          _releaseViewmodels[modifiedIndex] =
              ReleaseViewmodel(realm, releases[modifiedIndex]);
        }

        // Handle initialization (or any mismatch really, but that shouldn't happen)
        if (releases.length != _releaseViewmodels.length) {
          _releaseViewmodels.insertAll(
              0, releases.map((item) => ReleaseViewmodel(realm, item)));
          _releaseViewmodels.length = releases.length;
        }

        return ListView.builder(
          itemCount: _releaseViewmodels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_releaseViewmodels[index].title),
              subtitle: Text(_releaseViewmodels[index].barcode),
            );
          },
        );
      },
    );
  }
}
