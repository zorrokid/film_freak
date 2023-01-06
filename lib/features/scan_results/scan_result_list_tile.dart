import 'package:flutter/material.dart';
import 'package:flutter_todo/viewmodels/release_viewmodel.dart';
import 'package:realm/realm.dart';

typedef OnDeleteCallback = void Function(ObjectId id);
typedef OnEditCallback = void Function(ObjectId id);

class ScanResultListTile extends StatelessWidget {
  final ReleaseViewmodel viewModel;
  final OnDeleteCallback onDelete;
  const ScanResultListTile({
    super.key,
    required this.viewModel,
    required this.onDelete,
  });

  void menuItemSelected(String? value) {
    switch (value) {
      case 'delete':
        onDelete(viewModel.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(viewModel.title),
      subtitle: Text(viewModel.barcode),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ];
        },
        onSelected: menuItemSelected,
      ),
      onTap: () => {},
    );
  }
}
